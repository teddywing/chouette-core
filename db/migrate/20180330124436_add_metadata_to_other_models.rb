class AddMetadataToOtherModels < ActiveRecord::Migration
  def change
    [
      Api::V1::ApiKey,
      Calendar,
      Chouette::AccessLink,
      Chouette::AccessPoint,
      Chouette::Company,
      Chouette::ConnectionLink,
      Chouette::GroupOfLine,
      Chouette::JourneyPattern,
      Chouette::Line,
      Chouette::Network,
      Chouette::PtLink,
      Chouette::PurchaseWindow,
      Chouette::RoutingConstraintZone,
      Chouette::StopArea,
      Chouette::StopPoint,
      Chouette::TimeTable,
      Chouette::Timeband,
      Chouette::VehicleJourney,
      ComplianceCheckSet,
      ComplianceControlSet,
    ].each do |model|
      add_column model.table_name, :metadata, :jsonb, default: {}
    end
  end
end
