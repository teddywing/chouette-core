RSpec.describe Import, :type => :model do

  it { should belong_to(:referential) }
  it { should belong_to(:workbench) }
  it { should belong_to(:parent) }

  it { should enumerize(:status).in("aborted", "canceled", "failed", "new", "pending", "running", "successful") }

  it { should validate_presence_of(:file) }
  it { should validate_presence_of(:referential) }
  it { should validate_presence_of(:workbench) }

  let(:workbench_import) { build_stubbed(:workbench_import) }
  let(:workbench_import_with_completed_steps) do
    workbench_import = build_stubbed(
      :workbench_import,
      total_steps: 2,
      current_step: 2
    )
  end

  let(:netex_import) do
    netex_import = build_stubbed(
      :netex_import,
      parent: workbench_import
    )
  end

  describe "#notify_parent" do
    it "must call #child_change on its parent" do
      allow(netex_import).to receive(:update)

      expect(workbench_import).to receive(:child_change).with(netex_import)

      netex_import.notify_parent
    end

    it "must update the :notified_parent_at field of the child import" do
      allow(workbench_import).to receive(:child_change)

      Timecop.freeze(DateTime.now) do
        expect(netex_import).to receive(:update).with(
          notified_parent_at: DateTime.now
        )

        netex_import.notify_parent
      end
    end
  end

  describe "#child_change" do
    shared_examples(
      "updates :status to failed when child status indicates failure"
    ) do |failure_status|
      it "updates :status to failed when child status indicates failure" do
        allow(workbench_import).to receive(:update)

        netex_import = build_stubbed(
          :netex_import,
          parent: workbench_import,
          status: failure_status
        )

        expect(workbench_import).to receive(:update).with(status: 'failed')

        workbench_import.child_change(netex_import)
      end
    end

    include_examples(
      "updates :status to failed when child status indicates failure",
      "failed"
    )
    include_examples(
      "updates :status to failed when child status indicates failure",
      "aborted"
    )
    include_examples(
      "updates :status to failed when child status indicates failure",
      "canceled"
    )

    it "updates :status to successful when #ready?" do
      expect(workbench_import).to receive(:update).with(status: 'successful')

      workbench_import.child_change(netex_import)
    end

    it "updates :status to failed when #ready? and child is failed" do
      netex_import = build_stubbed(
        :netex_import,
        parent: workbench_import,
        status: :failed
      )

      expect(workbench_import).to receive(:update).with(status: 'failed')

      workbench_import.child_change(netex_import)
    end

    shared_examples(
      "doesn't update :status if parent import status is finished"
    ) do |finished_status|
      it "doesn't update :status if parent import status is finished" do
        workbench_import = build_stubbed(
          :workbench_import,
          total_steps: 2,
          current_step: 2,
          status: finished_status
        )
        child = double('Import')

        expect(workbench_import).not_to receive(:update)

        workbench_import.child_change(child)
      end
    end

    include_examples(
      "doesn't update :status if parent import status is finished",
      "successful"
    )
    include_examples(
      "doesn't update :status if parent import status is finished",
      "failed"
    )
    include_examples(
      "doesn't update :status if parent import status is finished",
      "aborted"
    )
    include_examples(
      "doesn't update :status if parent import status is finished",
      "canceled"
    )
  end

  describe "#ready?" do
    it "returns true if #current_step == #total_steps" do
      import = build_stubbed(
        :import,
        total_steps: 4,
        current_step: 4
      )

      expect(import.ready?).to be true
    end

    it "returns false if #current_step != #total_steps" do
      import = build_stubbed(
        :import,
        total_steps: 6,
        current_step: 3
      )

      expect(import.ready?).to be false
    end
  end
end
