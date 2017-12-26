class ReferentialCloning < ActiveRecord::Base
  include AASM
  belongs_to :source_referential, class_name: 'Referential'
  belongs_to :target_referential, class_name: 'Referential'
  after_commit :clone, on: :create

  def clone
    ReferentialCloningWorker.perform_async(id)
  end

  def clone!
    run!

    AF83::SchemaCloner
      .new(source_referential.slug, target_referential.slug)
      .clone_schema

    successful!
  rescue Exception => e
    Rails.logger.error "Clone failed : #{e}"
    failed!
  end

  private

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
