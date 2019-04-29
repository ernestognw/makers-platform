class Equipment < ApplicationRecord
  audited
  mount_uploader :image, ImageUploader

  has_many :equipment_materials, dependent: :destroy
  has_many :materials, through: :equipment_materials
  has_many :equipment_capabilities, dependent: :destroy
  has_many :capabilities, through: :equipment_capabilities
  has_many :available_hours, dependent: :destroy
  has_many :reservations
  belongs_to :lab_space

  validates :name, :description, :lab_space, presence: true

  accepts_nested_attributes_for :available_hours

  def self.search(name)
    if name.present?
      where('equipment.name ILIKE ?', "%#{name}%")
    else
      Equipment.all
    end
  end

  def self.search_by(relation, query)
    if query.present?
      names = query.split(/[,]+/).collect(&:strip)
      joins(relation).where("#{relation}.name ILIKE ANY ( array[?] )", names).distinct
    else
      all
    end
  end

  def self.materials
    Material.joins(:equipment).where(equipment: { id: ids })
  end

  def self.capabilities
    Capability.joins(:equipment).where(equipment: { id: ids })
  end
end
