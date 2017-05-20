class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user_context, record)
    @user = user_context.user
    @referential = user_context.context[:referential]
    @record = record
  end

  attr_accessor :referential
  def referential
    @referential ||= record_referential
  end

  def record_referential
    record.referential if record.respond_to?(:referential)
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  def boiv_read_offer?
    organisation_match? && user.has_permission?('boiv:read_offer')
  end

  def organisation_match?
    user.organisation == organisation
  end

  def organisation
    # When sending permission to react UI, we don't have access to record object for edit & destroy.. actions
    organisation = record.is_a?(Symbol) ? nil : record.try(:organisation)
    organisation or referential.try :organisation
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
