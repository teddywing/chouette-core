require 'rails_helper'

RSpec.describe ReferentialMetadata, :type => :model do
  it { should belong_to(:referential) }
  it { should belong_to(:referential_source) }
end
