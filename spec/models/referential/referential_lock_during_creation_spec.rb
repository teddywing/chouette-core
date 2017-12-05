RSpec.describe Referential, type: :model do

  context "when two identical Referentials are created, only one is saved" do
    let( :workbench ){ create :workbench }

    it "works synchronously" do
      referential_1 = build(
        :referential,
        workbench: workbench,
        organisation: workbench.organisation
      )
      referential_2 = referential_1.dup
      referential_2.slug = "#{referential_1.slug}_different"

      metadata_1 = build(:referential_metadata)
      metadata_2 = metadata_1.dup

      referential_1.metadatas << metadata_1
      referential_2.metadatas << metadata_2

      referential_1.save
      referential_2.save

      expect(referential_1).to be_persisted
      expect(referential_2).not_to be_persisted
    end

    it "works asynchronously", truncation: true do
      begin
        referential_1 = build(
          :referential,
          workbench: workbench,
          organisation: workbench.organisation
        )
        referential_2 = referential_1.dup
        referential_2.slug = "#{referential_1.slug}_different"
        referential_3 = nil

        metadata_1 = build(:referential_metadata)
        metadata_2 = metadata_1.dup

        referential_1.metadatas << metadata_1
        referential_2.metadatas << metadata_2

        thread_1 = Thread.new do
          ActiveRecord::Base.transaction do
            # seize LOCK
            referential_1.save
            sleep 10
            # release LOCK
          end
        end

        thread_2 = Thread.new do
          sleep 5
          ActiveRecord::Base.transaction do
            # waits for LOCK, (because of sleep 5)
            referential_2.save
            # when lock was eventually obtained validation failed
            referential_3 = create(:referential)
          end
        end

        thread_1.join
        thread_2.join

        expect(referential_1).to be_persisted
        expect(referential_2).not_to be_persisted
        expect(referential_3).to be_persisted
      ensure
        Apartment::Tenant.drop(referential_1.slug) if referential_1.persisted?
        Apartment::Tenant.drop(referential_2.slug) if referential_2.persisted?

        if referential_3.try(:persisted?)
          Apartment::Tenant.drop(referential_3.slug)
        end
      end
    end
  end
end
