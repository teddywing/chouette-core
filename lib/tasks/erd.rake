namespace :generate do

  desc "Create model diagrams for Chouette"
  task :model_diagram  => :environment do
    sh "bundle exec rake erd only='Organisation,Referential,User,Workbench' filename='organisation' title='Organisation'"
    sh "bundle exec rake erd only='Calendar,Referential,ReferentialMetadata,Chouette::Line,Chouette::Route,Chouette::JourneyPattern,Chouette::VehicleJourney,Chouette::VehicleJourneyAtStop,Chouette::TimeTable,Chouette::TimeTableDate,Chouette::TimeTablePeriod,Chouette::Footnote,Chouette::Network,Chouette::Company,Chouette::StopPoint,Chouette::StopArea' filename='offer_datas' title='Offer Datas'"
    sh "bundle exec rake erd only='Organisation,StopAreaReferential,StopAreaReferentialSync,StopAreaReferentialSyncMessage,StopAreaReferentialMembership,LineReferential,LineReferentialSync,LineReferentialSyncMessage,LineReferentialMembership' filename='referentiels_externes' title='Référentiels externes'"
    sh "bundle exec rake erd only='NetexImport,Import,WorkbenchImport,ImportResource,ImportMessage' filename='import' title='Import'"
    sh "bundle exec rake erd only='ComplianceControlSet,ComplianceControlBlock,ComplianceControl,ComplianceCheckSet,ComplianceCheckBlock,ComplianceCheck,ComplianceCheckResource,ComplianceCheckMessage' filename='validation' title='Validation'"
    #sh "bundle exec rake erd only='VehicleJourney,VehicleJourneyExport' filename='export' title='Export'"
    #sh "bundle exec rake erd only='' filename='intégration' title='Integration'"
    #sh "bundle exec rake erd only='' filename='fusion' title='Fusion'"
    #sh "bundle exec rake erd only='' filename='publication' title='Publication'"
  end

end
