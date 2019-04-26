class UserPolicy < ApplicationPolicy
  def index?
    return false unless user

    user.superadmin? || user.admin? || user.lab_admin?
  end

  def show?
    return false unless user

    user.id == record.id || user.superadmin? || user.admin? || user.lab_admin?
  end

  def create?
    user.blank?
  end

  def update?
    return false unless user

    user.id == record.id || user.superadmin? || user.admin?
  end

  def destroy?
    return false unless user

    user.id == record.id || user.superadmin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end