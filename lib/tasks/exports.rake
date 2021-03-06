require 'csv'
require 'tasks/helpers/simple_interfaces'

namespace :export do
  desc "Notify parent imports when children finish"
  task notify_parent: :environment do
    ParentNotifier.new(Import).notify_when_finished
  end

  desc "Mark old unfinished Netex imports as 'aborted'"
  task netex_abort_old: :environment do
    NetexImport.abort_old
  end

  desc "export companies in the give LineReferential using the given exporter"
  task :companies, [:referential_id, :configuration_name, :filepath, :logs_output_dir] => :environment do |t, args|
    args.with_defaults(filepath: "./companies.csv", logs_output_dir: "./log/exporters/")
    FileUtils.mkdir_p args[:logs_output_dir]

    referential = LineReferential.find args[:referential_id]
    exporter = SimpleExporter.create configuration_name: args[:configuration_name], filepath: args[:filepath]
    exporter.configure do |config|
      config.collection = referential.companies.order(:name)
    end

    SimpleInterfacesHelper.run_interface_controlling_interruption exporter, :export, args
  end

  desc "export lines in the give LineReferential using the given exporter"
  task :lines, [:referential_id, :configuration_name, :filepath, :logs_output_dir] => :environment do |t, args|
    args.with_defaults(filepath: "./companies.csv", logs_output_dir: "./log/exporters/")
    FileUtils.mkdir_p args[:logs_output_dir]

    referential = LineReferential.find args[:referential_id]
    exporter = SimpleExporter.create configuration_name: args[:configuration_name], filepath: args[:filepath]
    exporter.configure do |config|
      config.collection = referential.lines.order(:name)
    end

    SimpleInterfacesHelper.run_interface_controlling_interruption exporter, :export, args
  end

  desc "export a complete offer from the given referential in the given X next days"
  task :full_offer, [:referential_id, :configuration_name, :timelapse, :output_dir, :logs_output_dir] => :environment do |t, args|
    referential = Referential.find args[:referential_id]
    args.with_defaults(output_dir: "#{referential.name.parameterize}/#{Time.now.strftime "%y%m%d%H%M"}", logs_output_dir: "./log/exporters/", timelapse: 90)

    referential.switch

    journeys = Chouette::VehicleJourney.with_matching_timetable (Time.now.to_date..args[:timelapse].to_i.days.from_now.to_date)
    if journeys.count == 0
      puts "No maching journeys were found".red
    else
      exports_group = SimpleInterfacesGroup.new "Export Complet \"#{referential.name}\" du #{Time.now.to_date} au #{args[:timelapse].to_i.days.from_now.to_date}"
      exports_group.shared_options = {verbose: true, output_dir: args[:output_dir]}

      exporter = SimpleJsonExporter.create configuration_name: "#{args[:configuration_name]}_companies", filepath: "#{args[:output_dir]}/service_type.json"
      ids = journeys.pluck :company_id
      ids += journeys.joins(route: :line).pluck :"lines.company_id"

      exporter.configure do |config|
        config.collection = Chouette::Company.where(id: ids.uniq).order('name')
      end

      exports_group.add_interface exporter, "Services Types", :export

      exporter = SimpleJsonExporter.create configuration_name: "#{args[:configuration_name]}_schedules", filepath: "#{args[:output_dir]}/schedule.json"
      exporter.configure do |config|
        config.collection = journeys.where("custom_field_values->>'capacity' IS NOT NULL")
      end

      exports_group.add_interface exporter, "Schedules", :export

      exporter = SimpleJsonExporter.create configuration_name: "#{args[:configuration_name]}_routes", filepath: "#{args[:output_dir]}/route.json"
      exporter.configure do |config|
        config.collection = Chouette::JourneyPattern.where(id: journeys.pluck(:journey_pattern_id).uniq)
      end

      exports_group.add_interface exporter, "Routes", :export

      exporter = SimpleJsonExporter.create configuration_name: "#{args[:configuration_name]}_stops", filepath: "#{args[:output_dir]}/station.json"
      exporter.configure do |config|
        config.collection = Chouette::StopArea.where(id: journeys.joins(:stop_points).pluck(:"stop_points.stop_area_id").uniq).order('parent_id ASC NULLS FIRST')
      end

      exports_group.add_interface exporter, "Stops", :export

      exporter = SimpleJsonExporter.create configuration_name: "#{args[:configuration_name]}_journeys", filepath: "#{args[:output_dir]}/service.json"
      exporter.configure do |config|
        config.collection = journeys
      end

      exports_group.add_interface exporter, "Services", :export

      exports_group.run
    end
  end
end
