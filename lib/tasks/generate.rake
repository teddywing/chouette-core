namespace :generate do

  desc "Create model diagrams for Chouette"
  task :model_diagram  => :environment do
    sh "bundle exec rake erd only='Calendar,Referential,Chouette::Line,Chouette::Route,Chouette::JourneyPattern,Chouette::VehicleJourney,Chouette::VehicleJourneyAtStop,Chouette::TimeTable,Chouette::TimeTableDate,Chouette::TimeTablePeriod,Chouette::Footnote,Chouette::Network,Chouette::Company,Chouette::StopPoint,Chouette::StopArea' filename='offer_datas' title='Offer Datas'"
    sh "bundle exec rake erd only='Organisation,Referential,User,Workbench' filename='organisation' title='Organisation'"
  end

end
