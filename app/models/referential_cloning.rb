class ReferentialCloning < ActiveRecord::Base
  include AASM
  belongs_to :source_referential, class_name: 'Referential'
  belongs_to :target_referential, class_name: 'Referential'

  aasm column: :status do
    state :new, :initial => true
    state :pending
    state :successful
    state :failed

    event :run do
      transitions :from => [:new, :failed], :to => :pending
    end

    event :successful do
      transitions :from => [:pending, :failed], :to => :successful
    end

    event :failed do
      transitions :from => :pending, :to => :failed
    end
  end
end
