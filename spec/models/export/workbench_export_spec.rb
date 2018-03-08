RSpec.describe Export::Workbench, type: [:model, :with_commit] do
  it { should validate_presence_of(:timelapse) }

  it "should set options" do
    expect(Export::Workbench.options).to have_key :timelapse
    expect(Export::Workbench.options[:timelapse][:required]).to be_truthy
    expect(Export::Workbench.options[:timelapse][:default_value]).to eq 90
    expect(Export::Workbench.options[:timelapse][:type]).to eq :integer
  end
end
