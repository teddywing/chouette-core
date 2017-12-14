require "rails_helper"

RSpec.describe Merge do

  it "should work" do
    referential_metadata = FactoryGirl.create(:referential_metadata)
    referential = FactoryGirl.create :workbench_referential, metadatas: [referential_metadata]

    merge = Merge.create!(workbench: referential.workbench, referentials: [referential, referential])
    merge.merge!
  end

end
