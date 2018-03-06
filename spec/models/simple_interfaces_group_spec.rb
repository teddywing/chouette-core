RSpec.describe SimpleInterfacesGroup do
  context "with successful interfaces" do
    before do
      create :stop_area
      SimpleExporter.define :test_1 do |config|
        config.collection = Chouette::StopArea.all
        config.key = "name"
        config.add_column :name
      end

      SimpleExporter.define :test_2 do |config|
        config.collection = Chouette::StopArea.all
        config.key = "name"
        config.add_column :lat, attribute: :latitude
      end
    end

    it "should run all interfaces" do
      test_1 = SimpleExporter.new(configuration_name: :test_1, filepath: "tmp/test1.csv")
      test_2 = SimpleExporter.new(configuration_name: :test_2, filepath: "tmp/test1.csv")

      expect(test_1).to receive(:export).and_call_original
      expect(test_2).to receive(:export).and_call_original

      group = SimpleInterfacesGroup.new "group"
      group.add_interface test_1, "Test 1", :export
      group.add_interface test_2, "Test 2", :export
      group.run
    end
  end
end
