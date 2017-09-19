RSpec.describe ModelAttribute do
  describe ".define" do
    it "adds a new instance of ModelAttribute to @@all" do
      ModelAttribute.define(:route, :name, :string)

      expect(ModelAttribute.all.length).to eq(1)

      model_attr = ModelAttribute.all.first

      expect(model_attr).to be_an_instance_of(ModelAttribute)
      expect(model_attr.klass).to eq(:route)
      expect(model_attr.name).to eq(:name)
      expect(model_attr.data_type).to eq(:string)
    end
  end
end
