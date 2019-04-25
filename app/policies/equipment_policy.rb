class EquipmentPolicy < ManagedModelsPolicy
  def new?
    return false unless user
    return user.manages?(record.lab_space) if user.admin? || user.lab_admin?

    user.superadmin?
  end

  class Scope < Scope
    def resolve_admin
      user.managed_equipment
    end
  end
end
