class BoivPolicy < ApplicationPolicy

  def boiv_read_offer?
    organisation_match? && user.has_permission?('boiv:read-offer')
  end

  def index?
    boiv_read_offer?
  end

  def show?
    boiv_read_offer?
  end
end
