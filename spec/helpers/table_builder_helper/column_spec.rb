require 'spec_helper'

describe TableBuilderHelper::Column do
  describe "#header_label" do
    it "returns the column @name if present" do
      expect(
        TableBuilderHelper::Column.new(
          name: 'ID Codif',
          attribute: nil
        ).header_label
      ).to eq('ID Codif')
    end

    it "returns the I18n translation of @key if @name not present" do
      expect(
        TableBuilderHelper::Column.new(
          key: :phone,
          attribute: 'phone'
        ).header_label(Chouette::Company)
      ).to eq('Numéro de téléphone')
    end
  end
end
