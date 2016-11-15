require 'rails_helper'

RSpec.describe CleanUpResult, :type => :model do
  it { should belong_to(:clean_up) }
end
