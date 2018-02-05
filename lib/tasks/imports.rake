namespace :import do
  desc "Notify parent imports when children finish"
  task notify_parent: :environment do
    ParentImportNotifier.notify_when_finished
  end

  desc "Mark old unfinished Netex imports as 'aborted'"
  task netex_abort_old: :environment do
    NetexImport.abort_old
  end
end
