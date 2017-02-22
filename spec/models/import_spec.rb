require 'rails_helper'

RSpec.describe Import, :type => :model do
  it { should belong_to(:referential) }
  it { should belong_to(:workbench) }

  it { should validate_presence_of(:file) }
end
