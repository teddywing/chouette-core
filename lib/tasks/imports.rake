namespace :import do
  desc "Notify parent imports when children finish"
  task notify_parent: :environment do
    ParentNotifier.new(Import).notify_when_finished
  end
end
