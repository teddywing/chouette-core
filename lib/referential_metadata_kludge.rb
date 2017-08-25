module ReferentialMetadataKludge extend self
  
  def make_metadata_from_name!( name, referential_id: )
    line_ids = Chouette::Line.where(
      objectid: ['C00108', 'C00109'].map do |id|
        "STIF:CODIFLIGNE:Line:#{id}"
      end
    ).pluck(:id)

    ReferentialMetadata.create!(
      referential_id: referential_id,
      line_ids: line_ids,
      periodes: name_to_periods(name))
  end

  def name_to_periods name
    {'offre1' => [Date.new(2017,3,1)...Date.new(2017,4,1)],
     'offre2' => [Date.new(2017,3,1)...Date.new(2018,1,1)],
     'OFFRE_TRANSDEV_20170301122517' => [Date.new(2017,3,1)...Date.new(2017,4,1)],
     'OFFRE_TRANSDEV_20170301122519' => [Date.new(2017,3,1)...Date.new(2018,1,1)]}.fetch name
  end

end
