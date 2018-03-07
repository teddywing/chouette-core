RSpec.describe Export::Base, type: :model do

  it { should belong_to(:referential) }
  it { should belong_to(:workbench) }
  it { should belong_to(:parent) }

  it { should enumerize(:status).in("aborted", "canceled", "failed", "new", "pending", "running", "successful", "warning") }

  it { should validate_presence_of(:workbench) }
  it { should validate_presence_of(:creator) }

  include ActionDispatch::TestProcess
  it { should allow_value(fixture_file_upload('OFFRE_TRANSDEV_2017030112251.zip')).for(:file) }
  it { should_not allow_value(fixture_file_upload('users.json')).for(:file).with_message(I18n.t('errors.messages.extension_whitelist_error', extension: '"json"', allowed_types: "zip")) }

  let(:workbench_export) {netex_export.parent}
  let(:workbench_export_with_completed_steps) do
    build_stubbed(
      :workbench_export,
      total_steps: 2,
      current_step: 2
    )
  end

  let(:netex_export) do
    build_stubbed(
      :netex_export
    )
  end

  describe ".abort_old" do
    it "changes exports older than 4 hours to aborted" do
      Timecop.freeze(Time.now) do
        old_export = create(
          :workbench_export,
          status: 'pending',
          created_at: 4.hours.ago - 1.minute
        )
        current_export = create(:workbench_export, status: 'pending')

        Export::Base.abort_old

        expect(current_export.reload.status).to eq('pending')
        expect(old_export.reload.status).to eq('aborted')
      end
    end

    it "doesn't work on exports with a `finished_status`" do
      Timecop.freeze(Time.now) do
        export = create(
          :workbench_export,
          status: 'successful',
          created_at: 4.hours.ago - 1.minute
        )

        Export::Base.abort_old

        expect(export.reload.status).to eq('successful')
      end
    end

    it "only works on the caller type" do
      Timecop.freeze(Time.now) do
        workbench_export = create(
          :workbench_export,
          status: 'pending',
          created_at: 4.hours.ago - 1.minute
        )
        netex_export = create(
          :netex_export,
          status: 'pending',
          created_at: 4.hours.ago - 1.minute
        )

        Export::Netex.abort_old

        expect(workbench_export.reload.status).to eq('pending')
        expect(netex_export.reload.status).to eq('aborted')
      end
    end
  end

  describe "#destroy" do
    it "must destroy all child exports" do
      netex_export = create(:netex_export)

      netex_export.parent.destroy

      expect(netex_export.parent).to be_destroyed
      expect(Export::Netex.count).to eq(0)
    end

    it "must destroy all associated Export::Messages" do
      export = create(:export)
      create(:export_resource, export: export)

      export.destroy

      expect(Export::Resource.count).to eq(0)
    end

    it "must destroy all associated Export::Resources" do
      export = create(:export)
      create(:export_message, export: export)

      export.destroy

      expect(Export::Message.count).to eq(0)
    end
  end

  describe "#notify_parent" do
    it "must call #child_change on its parent" do
      allow(netex_export).to receive(:update)

      expect(workbench_export).to receive(:child_change)

      netex_export.notify_parent
    end

    it "must update the :notified_parent_at field of the child export" do
      allow(workbench_export).to receive(:child_change)

      Timecop.freeze(DateTime.now) do
        expect(netex_export).to receive(:update).with(
          notified_parent_at: DateTime.now
        )

        netex_export.notify_parent
      end
    end
  end

  describe "#child_change" do
    it "calls #update_status" do
      allow(workbench_export).to receive(:update)

      expect(workbench_export).to receive(:update_status)
      workbench_export.child_change
    end
  end

  describe "#update_status" do
    shared_examples(
      "updates :status to failed when >=1 child has failing status"
    ) do |failure_status|
      it "updates :status to failed when >=1 child has failing status" do
        workbench_export = create(:workbench_export)
        create(
          :netex_export,
          parent: workbench_export,
          status: failure_status
        )

        workbench_export.update_status

        expect(workbench_export.status).to eq('failed')
      end
    end

    include_examples(
      "updates :status to failed when >=1 child has failing status",
      "failed"
    )
    include_examples(
      "updates :status to failed when >=1 child has failing status",
      "aborted"
    )
    include_examples(
      "updates :status to failed when >=1 child has failing status",
      "canceled"
    )

    it "updates :status to successful when all children are successful" do
      workbench_export = create(:workbench_export)
      exports = create_list(
        :netex_export,
        2,
        parent: workbench_export,
        status: 'successful'
      )

      workbench_export.update_status

      expect(workbench_export.status).to eq('successful')
    end

    it "updates :status to failed when any child has failed" do
      workbench_export = create(:workbench_export)
      [
        'failed',
        'successful'
      ].each do |status|
        create(
          :netex_export,
          parent: workbench_export,
          status: status
        )
      end

      workbench_export.update_status

      expect(workbench_export.status).to eq('failed')
    end

    it "updates :status to warning when any child has warning or successful" do
      workbench_export = create(:workbench_export)
      [
        'warning',
        'successful'
      ].each do |status|
        create(
          :netex_export,
          parent: workbench_export,
          status: status
        )
      end

      workbench_export.update_status

      expect(workbench_export.status).to eq('warning')
    end

    it "updates :ended_at to now when status is finished" do
      workbench_export = create(:workbench_export)
      create(
        :netex_export,
        parent: workbench_export,
        status: 'failed'
      )

      Timecop.freeze(Time.now) do
        workbench_export.update_status

        expect(workbench_export.ended_at).to eq(Time.now)
      end
    end
  end
end
