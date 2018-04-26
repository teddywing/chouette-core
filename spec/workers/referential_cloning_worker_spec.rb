require 'spec_helper'
require 'ostruct'

RSpec.describe ReferentialCloningWorker do
  alias_method :worker, :subject

  context "given a referential cloning" do
    let(:id) { double }
    let(:referential_cloning) { double }

    it "invokes the clone! method of the associated ReferentialCloning" do
      expect(ReferentialCloning).to receive(:find).with(id).and_return(referential_cloning)
      expect(referential_cloning).to receive(:clone_with_status!)

      worker.perform(id)
    end
  end

  context 'with existing Referential' do
    it "preserve existing data", truncation: true do
      source_referential = create :referential

      source_referential.switch
      source_time_table = create :time_table

      target_referential = create :referential, created_from: source_referential

      cloning = ReferentialCloning.create source_referential: source_referential, target_referential: target_referential
      worker.perform(cloning.id)

      target_referential.switch

      expect(Chouette::TimeTable.where(objectid: source_time_table.objectid).exists?)
    end
  end
end
