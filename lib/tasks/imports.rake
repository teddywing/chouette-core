namespace :import do
  desc "Notify parent imports when children finish"
  task notify_parent: :environment do
    ParentImportNotifier.notify_when_finished
  end

  desc "Mark old unfinished imports as 'aborted'"
  task abort_old: :environment do
    Import.abort_old
  end
end
