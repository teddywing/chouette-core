RSpec.describe NetexImport, type: :model do
  describe "#destroy" do
    it "must destroy its associated Referential if ready: false" do
      workbench_import = create(:workbench_import)
      referential_ready_false = create(:referential, ready: false)
      referential_ready_true = create(:referential, ready: true)
      create(
        :netex_import,
        parent: workbench_import,
        referential: referential_ready_false
      )
      create(
        :netex_import,
        parent: workbench_import,
        referential: referential_ready_true
      )

      workbench_import.destroy

      expect(
        Referential.where(id: referential_ready_false.id).exists?
      ).to be false
      expect(
        Referential.where(id: referential_ready_true.id).exists?
      ).to be true
    end
  end
end
