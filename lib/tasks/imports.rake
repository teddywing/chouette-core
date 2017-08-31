namespace :import do
  desc "Notify parent imports when children finish"
  task notify_parent: :environment do
    ParentImportNotifier.notify_when_finished
  end
end
