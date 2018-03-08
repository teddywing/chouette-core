class Export::Netex < Export::Base
  after_commit :call_iev_callback, on: :create

  private

  def iev_callback_url
    URI("#{Rails.configuration.iev_url}/boiv_iev/referentials/exporter/new?id=#{id}")
  end

  def self.user_visible?
    false
  end

  def destroy_non_ready_referential
    if referential && !referential.ready
      referential.destroy
    end
  end
end
