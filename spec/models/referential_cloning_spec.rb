require 'spec_helper'

RSpec.describe ReferentialCloning, :type => :model do
  alias_method :referential_cloning, :subject

  it 'should have a valid factory' do
    expect(FactoryGirl.build(:referential_cloning)).to be_valid
  end

  it { should belong_to :source_referential }
  it { should belong_to :target_referential }

  describe 'after commit' do
    let(:referential_cloning) { FactoryGirl.create(:referential_cloning) }

    it 'invoke clone method' do
    expect(referential_cloning).to receive(:clone)
    referential_cloning.run_callbacks(:commit)
    end
  end

  describe '#clone' do
    let(:referential_cloning) { FactoryGirl.create(:referential_cloning) }

    it "should schedule a job in worker" do
      expect{referential_cloning.clone}.to change {ReferentialCloningWorker.jobs.count}.by(1)
    end
  end

  describe '#clone!' do
    let(:source_referential) { Referential.new slug: "source"}
    let(:target_referential) { Referential.new slug: "target"}
    let(:referential_cloning) do
      ReferentialCloning.new source_referential: source_referential,
                             target_referential: target_referential
    end

    let(:cloner) { double }

    before do
      allow(AF83::SchemaCloner).to receive(:new).and_return cloner
      allow(cloner).to receive(:clone_schema)
    end

    it 'creates a schema cloner with source and target schemas and clone schema' do
      expect(AF83::SchemaCloner).to receive(:new).with(source_referential.slug, target_referential.slug).and_return(cloner)
      expect(cloner).to receive(:clone_schema)

      referential_cloning.clone!
    end

    context 'when clone_schema is performed without error' do
      it "should have successful status" do
        referential_cloning.clone!
        expect(referential_cloning.status).to eq("successful")
      end
    end

    context 'when clone_schema raises an error' do
      it "should have failed status" do
        expect(cloner).to receive(:clone_schema).and_raise("#fail")
        referential_cloning.clone!
        expect(referential_cloning.status).to eq("failed")
      end
    end

    it "defines started_at" do
      referential_cloning.clone!
      expect(referential_cloning.started_at).not_to be(nil)
    end

    it "defines ended_at" do
      referential_cloning.clone!
      expect(referential_cloning.ended_at).not_to be(nil)
    end

  end
end
