require 'rails_helper'

RSpec.describe WorkbenchObjectIdentifier, type: :model do
  it { should belong_to :workbench }
end
