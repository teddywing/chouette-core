require "rails_helper"

RSpec.describe Merge do

  it "should work" do
    workbench = FactoryGirl.create :workbench
    referential = FactoryGirl.create :referential, workbench: workbench, organisation: workbench.organisation

    merge = Merge.create!(workbench: workbench, referentials: [referential])

    merge.merge!
  end

end
