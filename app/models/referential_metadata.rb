class ReferentialMetadata < ActiveRecord::Base
  belongs_to :referential
  belongs_to :referential_source, class_name: 'Referential'
  has_array_of :lines, class_name: 'Chouette::Line'

  validates :referential, presence: true
  validates :lines, presence: true
  validates :periodes, presence: true

  scope :include_lines, -> (line_ids) { where('line_ids && ARRAY[?]', line_ids) }
  scope :include_dateranges, -> (dateranges) { where('periodes && ARRAY[?]', dateranges) }

  def self.new_from from
    from.dup.tap do |metadata|
      metadata.referential_id = nil
    end
  end
end
