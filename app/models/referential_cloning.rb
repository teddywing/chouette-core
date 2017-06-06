class ReferentialCloning < ActiveRecord::Base
  include AASM
  belongs_to :source_referential, class_name: 'Referential'
  belongs_to :target_referential, class_name: 'Referential'
  after_commit :perform_clone, :on => :create

  private
  def perform_clone
    # ReferentialCloningWorker.perform_async(id)
    ReferentialCloningWorker.new.perform(id)
  end

  aasm column: :status do
    state :new, :initial => true
    state :pending
    state :successful
    state :failed

    event :run, after: :update_started_at do
      transitions :from => [:new, :failed], :to => :pending
    end

    event :successful, after: :update_ended_at do
      after do
        target_referential.update_attribute(:ready, true)
      end
      transitions :from => [:pending, :failed], :to => :successful
    end

    event :failed, after: :update_ended_at do
      transitions :from => :pending, :to => :failed
    end
  end

  def update_started_at
    update_attribute(:started_at, Time.now)
  end

  def update_ended_at
    update_attribute(:ended_at, Time.now)
  end
end
