class ApplicationPolicy
  attr_reader :current_referential, :record, :user

  # Make authorization by action easier
  def delete?
    destroy?
  end

  # Tie edit and update together, #edit?, do not override #edit?,
  # unless you want to break this tie on purpose
  def edit?
    update?
  end

  # Tie new and create together, do not override #new?,
  # unless you want to break this tie on purpose
  def new?
    create?
  end



  def initialize(user_context, record)
    @user                = user_context.user
    @current_referential = user_context.context[:referential]
    @record              = record
  end

  def archived?
    return @is_archived if instance_variable_defined?(:@is_archived)
    @is_archived = is_archived
  end

  def referential
    @referential ||=  current_referential || record_referential
  end

  def record_referential
    record.referential if record.respond_to?(:referential)
  end

  def index?
    show?
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

  private
  def is_archived
    !!case referential
    when Referential
      referential.archived_at
    else
      current_referential.try(:archived_at)
    end
  end
end
