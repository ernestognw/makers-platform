class LabPolicy < ManagedModelsPolicy
  def create?
    return false unless user
    return false if user.user?

    user.superadmin? || user.admin?
  end

  class Scope < Scope
    def resolve_admin
      return scope.all if user.superadmin?

      user.managed_labs
    end
  end
end
