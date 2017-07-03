class BoivPolicy < ApplicationPolicy


  def index?
    boiv_read_offer?
  end

  def show?
    boiv_read_offer?
  end
end
