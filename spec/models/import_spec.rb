RSpec.describe Import, :type => :model do

  it { should belong_to(:referential) }
  it { should belong_to(:workbench) }
  it { should belong_to(:parent) }

  it { should enumerize(:status).in("aborted", "canceled", "failed", "new", "pending", "running", "successful") }

  it { should validate_presence_of(:file) }
  it { should validate_presence_of(:referential) }
  it { should validate_presence_of(:workbench) }

  describe "#notify_parent" do
    it "must call #child_change on its parent" do
      workbench_import = build_stubbed(:workbench_import)
      netex_import = build_stubbed(
        :netex_import,
        parent: workbench_import
      )

      expect(workbench_import).to receive(:child_change).with(netex_import)

      netex_import.notify_parent
    end
  end

  describe "#child_change" do
    def updates_status_to_failed_when_child_status_indicates_failure(
      failure_status
    )
      workbench_import = build_stubbed(:workbench_import)
      allow(workbench_import).to receive(:update)

      netex_import = build_stubbed(
        :netex_import,
        parent: workbench_import,
        status: failure_status
      )

      expect(workbench_import).to receive(:update).with(status: 'failed')

      workbench_import.child_change(netex_import)
    end

    it "updates :status to failed when child status indicates failure" do
      updates_status_to_failed_when_child_status_indicates_failure('failed')
      updates_status_to_failed_when_child_status_indicates_failure('aborted')
      updates_status_to_failed_when_child_status_indicates_failure('canceled')
    end

    it "updates :status to successful when #ready?" do
      workbench_import = build_stubbed(
        :workbench_import,
        total_steps: 2,
        current_step: 2
      )
      netex_import = build_stubbed(
        :netex_import,
        parent: workbench_import
      )

      expect(workbench_import).to receive(:update).with(status: 'successful')

      workbench_import.child_change(netex_import)
    end

    it "updates :status to failed when #ready? and child is failed" do
      workbench_import = build_stubbed(
        :workbench_import,
        total_steps: 2,
        current_step: 2
      )
      netex_import = build_stubbed(
        :netex_import,
        parent: workbench_import,
        status: :failed
      )

      expect(workbench_import).to receive(:update).with(status: 'failed')

      workbench_import.child_change(netex_import)
    end
    # when status is failed, update status to failed
    # else when ready? update status to successful
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
