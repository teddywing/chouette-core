namespace :import do
  desc "Notify parent imports when children finish"
  task notify_parent: :environment do
    ParentImportNotifier.notify_when_finished
  end

  desc "import the given file with the corresponding importer"
  task :import, [:configuration_name, :filepath] => :environment do |t, args|
    importer = SimpleImporter.create configuration_name: args[:configuration_name], filepath: args[:filepath]
    puts "\e[33m***\e[0m Start importing"
    importer.import(verbose: true)
    puts "\n\e[33m***\e[0m Import done, status: " + (importer.status == "success" ? "\e[32m" : "\e[31m" ) + importer.status + "\e[0m"
  end
end
