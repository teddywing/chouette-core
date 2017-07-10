class Chouette::Footnote < Chouette::ActiveRecord
  belongs_to :line, inverse_of: :footnotes
  has_and_belongs_to_many :vehicle_journeys, :class_name => 'Chouette::VehicleJourney'

  validates_presence_of :line
  before_save :update_checksum

  def checksum_attributes
    attrs = ['code', 'label']
    self.slice(*attrs).values
  end

  def current_checksum_source
    source = self.checksum_attributes.map!{ |x| x || '-' }
    source.join('|')
  end

  def update_checksum
    self.checksum_source = self.current_checksum_source
    if self.checksum_source_changed?
      self.checksum = Digest::SHA256.new.hexdigest(self.checksum_source)
    end
  end
end
