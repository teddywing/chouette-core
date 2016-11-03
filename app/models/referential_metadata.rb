class ReferentialMetadata < ActiveRecord::Base
  belongs_to :referential
  belongs_to :referential_source, class_name: 'Referential'

  has_array_of :lines, class_name: 'Chouette::Line'

  def self.new_from from
    ReferentialMetadata.new({
      referential_source: from.referential_source,
      line_ids: from.line_ids,
      periodes: from.periodes
    })
  end
end
