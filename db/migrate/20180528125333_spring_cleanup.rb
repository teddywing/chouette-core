class SpringCleanup < ActiveRecord::Migration
  def change
    [:journey_frequencies, :timebands, :access_links, :access_points].each do |t|
      drop_table t
    end
  end
end
