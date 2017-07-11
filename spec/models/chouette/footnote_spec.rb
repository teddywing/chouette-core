require 'spec_helper'

describe Chouette::Footnote, type: :model do
  let(:footnote) { create(:footnote) }

  it { should validate_presence_of :line }

  context 'checksum' do
    it_behaves_like 'checksum support', :footnote

    context '#checksum_attributes' do
      it 'should return code and label' do
        expected = [footnote.code, footnote.label]
        expect(footnote.checksum_attributes).to include(*expected)
      end

      it 'should not return other atrributes' do
        expect(footnote.checksum_attributes).to_not include(footnote.updated_at)
      end
    end
  end
end
