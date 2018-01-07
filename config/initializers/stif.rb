Rails.application.config.to_prepare do
  Organisation.after_create do |organisation|
    line_referential      = LineReferential.find_by(name: "CodifLigne")
    stop_area_referential = StopAreaReferential.find_by(name: "Reflex")

    line_referential.organisations << organisation
    stop_area_referential.organisations << organisation

    organisation.workbenches.find_or_create_by(name: "Gestion de l'offre") do |workbench|
      workbench.line_referential      = line_referential
      workbench.stop_area_referential = stop_area_referential
      workbench.objectid_format = Workbench.objectid_format.stif_netex

      Rails.logger.debug "Create Workbench for #{organisation.name}"
    end
  end
end unless Rails.env.test?

Rails.application.config.to_prepare do
  Organisation.before_validation(on: :create) do |organisation|
    organisation.custom_view = "stif"
  end
end

Rails.application.config.to_prepare do
  Dashboard.default_class = Stif::Dashboard
end
