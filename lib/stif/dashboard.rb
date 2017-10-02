module Stif
  class Dashboard < ::Dashboard
    def workbench
      @workbench ||= current_organisation.workbenches.find_by(name: "Gestion de l'offre")
    end

    def referentials
      @referentials ||= @workbench.all_referentials
    end

    def calendars
      @calendars ||= Calendar.where('organisation_id = ? OR shared = ?', current_organisation.id, true)
    end
  end
end
