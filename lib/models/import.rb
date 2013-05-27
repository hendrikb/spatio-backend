class Import < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :url
  validates_presence_of :namespace
  validates_presence_of :format_definition

  belongs_to :format_definition

  def create_namespace
    # TODO: add fields
    ns = Namespace.create(name: namespace,
                                 table_name: namespace.parameterize('_').tableize)
    ns.create_table if ns.valid?
  end
end
