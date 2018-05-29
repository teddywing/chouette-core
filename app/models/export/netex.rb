class Export::Netex < Export::Base
  after_commit :call_iev_callback, on: :create
  option :export_type, collection: %w(line full), required: true do |val|
    val.full do
      option :duration, type: :integer, default_value: 90, required: true
    end
    val.line do
      option :line_code, collection: ->(referential){referential.lines.map{|l| [l.display_name, l.id]}}, depends_on_referential: true
    end
  end

  private

  def iev_callback_url
    URI("#{Rails.configuration.iev_url}/boiv_iev/referentials/exporter/new?id=#{id}")
  end

  def destroy_non_ready_referential
    if referential && !referential.ready
      referential.destroy
    end
  end
end
