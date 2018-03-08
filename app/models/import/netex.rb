require 'net/http'
class Import::Netex < Import::Base
  before_destroy :destroy_non_ready_referential

  after_commit :call_iev_callback, on: :create

  before_save def abort_unless_referential
    self.status = 'aborted' unless referential
  end

  validates_presence_of :parent

  private

  def iev_callback_url
    URI("#{Rails.configuration.iev_url}/boiv_iev/referentials/importer/new?id=#{id}")
  end

  def destroy_non_ready_referential
    if referential && !referential.ready
      referential.destroy
    end
  end
end
