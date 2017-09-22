RSpec.describe ModelAttribute do
  describe ".define" do
    it "adds a new instance of ModelAttribute to .all" do
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

  describe ".methods_by_class" do
    it "returns all ModelAttributes for a given class" do
      ModelAttribute.instance_variable_set(:@__all__, [
        ModelAttribute.new(:route, :name, :string),
        ModelAttribute.new(:route, :published_name, :string),
        ModelAttribute.new(:route, :direction, :string),
        ModelAttribute.new(:journey_pattern, :name, :string)
      ])

      expect(ModelAttribute.methods_by_class(:route)).to match_array([
        ModelAttribute.new(:route, :name, :string),
        ModelAttribute.new(:route, :published_name, :string),
        ModelAttribute.new(:route, :direction, :string)
      ])
    end
  end

  describe ".methods_by_class_and_type" do
    it "returns ModelAttributes of a certain class and type" do
      ModelAttribute.instance_variable_set(:@__all__, [
        ModelAttribute.new(:route, :name, :string),
        ModelAttribute.new(:route, :checked_at, :date),
        ModelAttribute.new(:journey_pattern, :name, :string),
        ModelAttribute.new(:journey_pattern, :section_status, :integer)
      ])

      expect(ModelAttribute.methods_by_class_and_type(:route, :string)).to match_array([
        ModelAttribute.new(:route, :name, :string)
      ])
    end
  end

  describe "#code" do
    it "returns a string representation of the attribute" do
      model_attr = ModelAttribute.new(:route, :name, :string)

      expect(model_attr.code).to eq('route#name')
    end
  end

  describe "#==" do
    it "returns true when :klass, :name, and :data_type attributes match" do
      route_name = ModelAttribute.new(:route, :name, :string)
      other_route_name = ModelAttribute.new(:route, :name, :string)

      expect(route_name == other_route_name).to be true
    end
  end
end
