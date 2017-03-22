require 'rails_helper'

RSpec.describe ImportMessage, :type => :model do
  it { should validate_presence_of(:criticity) }
  it { should belong_to(:import) }
  it { should belong_to(:resource) }
end
