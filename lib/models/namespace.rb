class Namespace < ActiveRecord::Base
  has_many :fields
  MANDATORY_FIELD_NAMESPACE = 'Mandatory Fields'

  validates :name, uniqueness: true

  def all_fields
    fields + mandatory_fields
  end

  def mandatory_fields
    Namespace.find_by_name(MANDATORY_FIELD_NAMESPACE).fields
  end
end
