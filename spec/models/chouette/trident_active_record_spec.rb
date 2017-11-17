# require 'spec_helper'

# describe Chouette::TridentActiveRecord, :type => :model do
#   subject { create(:time_table) }

#   it { should validate_presence_of :objectid }
#   it { should validate_uniqueness_of :objectid }

#   describe "#default_values" do
#     let(:object) { build(:time_table, objectid: nil) }

#     it 'should fill __pending_id__' do
#       object.default_values
#       expect(object.objectid.include?('__pending_id__')).to be_truthy
#     end
#   end

#   describe "#objectid" do
#     let(:object) { build(:time_table, objectid: nil) }

#     it 'should build objectid on create' do
#       object.save
#       objectid = object.get_objectid
#       id = "#{objectid.provider_id}:#{objectid.object_type}:#{objectid.local_id}:#{objectid.creation_id}"
#       expect(object.read_attribute(:objectid)).to eq(id)
#     end

#     it 'should not build new objectid is already set' do
#       id = "first:TimeTable:1-1:LOC"
#       object.objectid = id
#       object.save
#       expect(object.objectid).to eq(id)
#     end

#     xit 'should call default_values on create' do
#       expect(object).to receive(:default_values)
#       object.save
#     end

#     xit 'should not call default_values on update' do
#       object = create(:time_table)
#       expect(object).to_not receive(:default_values)
#       object.touch
#     end

#     it 'should create a new objectid when cleared' do
#       object.save
#       object.objectid = nil
#       object.save
#       expect(object.objectid).to be_truthy
#     end
#   end
# end
