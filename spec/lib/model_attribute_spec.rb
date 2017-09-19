RSpec.describe ModelAttribute do
  describe ".define" do
    it "adds a new instance of ModelAttribute to @@all" do
      expect do
        ModelAttribute.define(:route, :name, :string)
      end.to change { ModelAttribute.all.length }.by(1)

      model_attr = ModelAttribute.all.last

      expect(model_attr).to be_an_instance_of(ModelAttribute)
      expect(model_attr.klass).to eq(:route)
      expect(model_attr.name).to eq(:name)
      expect(model_attr.data_type).to eq(:string)
    end
  end

  describe "#code" do
    it "returns a string representation of the attribute" do
      model_attr = ModelAttribute.new(:route, :name, :string)

      expect(model_attr.code).to eq('route#name')
    end
  end
end
