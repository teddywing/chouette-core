module PaperTrailSupport
  extend ActiveSupport::Concern

  included do
    before_action :set_paper_trail_whodunnit

    def user_for_paper_trail
      current_user ? current_user.name : ''
    end
  end
end
