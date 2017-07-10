require 'spec_helper'

describe Chouette::Footnote do
  subject { build(:footnote) }
  it { should validate_presence_of :line }

  # context '#checksum_attributes' do
  #   it 'should return attributes values' do
  #     expect(subject.checksum_attributes).to eq [subject.code, subject.label]
  #   end
  # end

  # context '#current_checksum_source' do
  #   it 'should return instance current checksum source' do
  #     expect(subject.current_checksum_source).to eq("#{subject.code}|#{subject.label}")
  #   end

  #   it 'should replace nil attributes by dash (-)' do
  #     subject.code = nil
  #     expect(subject.current_checksum_source).to eq("-|#{subject.label}")
  #   end
  # end

  context '#checksum' do
    let(:footnote) { create(:footnote) }

    it 'should update checksum on update' do
      ap footnote.checksum_source
      ap footnote.checksum
    end
  end
end
