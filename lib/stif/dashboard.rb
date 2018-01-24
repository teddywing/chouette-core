module Stif
  class Dashboard < ::Dashboard
    def workbench
      @workbench ||= current_organisation.workbenches.find_by(name: "Gestion de l'offre")
    end

    def referentials
      @referentials ||= self.workbench.all_referentials
    end

    def calendars
      @calendars ||= Calendar.where('workgroup_id = ? OR shared = ?', @workbench.workgroup_id, true)
    end
  end
end
