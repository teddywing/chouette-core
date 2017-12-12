RSpec.describe Referential, type: :model do
  let (:workbench) { create(:workbench) }

  context "when two identical Referentials are created, only one is saved" do
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

        metadata_1 = build(:referential_metadata, referential: nil)
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

    it "works asynchronously when one is updated", truncation: true do
      begin
        referential_1 = nil
        referential_2 = nil

        ActiveRecord::Base.transaction do
          referential_1 = create(
            :referential,
            workbench: workbench,
            organisation: workbench.organisation
          )
          referential_2 = referential_1.dup
          referential_2.name = 'Another'
          referential_2.slug = "#{referential_1.slug}_different"
          referential_2.save!
        end

        metadata_2 = build(:referential_metadata, referential: nil)
        metadata_1 = metadata_2.dup

        thread_1 = Thread.new do
          ActiveRecord::Base.transaction do
            # seize LOCK
            referential_1.metadatas_attributes = [metadata_1.attributes]
            puts referential_1.save
            sleep 10
            # release LOCK
          end
        end

        thread_2 = Thread.new do
          sleep 5
          ActiveRecord::Base.transaction do
            # waits for LOCK, (because of sleep 5)
            referential_2.metadatas_attributes = [metadata_2.attributes]
            puts referential_2.save
          end
        end

        thread_1.join
        thread_2.join

        expect(referential_1).to be_valid
        expect(referential_2).not_to be_valid
      ensure
        Apartment::Tenant.drop(referential_1.slug) if referential_1.persisted?
        Apartment::Tenant.drop(referential_2.slug) if referential_2.persisted?
      end
    end
  end

  context "when two Referentials are created at the same time" do
    it "raises an error when the DB lock timeout is reached", truncation: true do
      begin
        referential_1 = build(
          :referential,
          workbench: workbench,
          organisation: workbench.organisation
        )
        referential_2 = referential_1.dup
        referential_2.slug = "#{referential_1.slug}_different"
        referential_3 = nil

        metadata_1 = build(:referential_metadata, referential: nil)
        metadata_2 = metadata_1.dup

        referential_1.metadatas << metadata_1
        referential_2.metadatas << metadata_2

        thread_1 = Thread.new do
          ActiveRecord::Base.transaction do
            ActiveRecord::Base.connection.execute("SET LOCAL lock_timeout = '1s'")

            # seize LOCK
            referential_1.save
            sleep 10
            # release LOCK
          end
        end

        thread_2 = Thread.new do
          sleep 5
          ActiveRecord::Base.transaction do
            ActiveRecord::Base.connection.execute("SET LOCAL lock_timeout = '1s'")
            # waits for LOCK, (because of sleep 5)
            referential_2.save
            # when lock was eventually obtained validation failed
            referential_3 = create(:referential)
          end
        end

        thread_1.join
        expect do
          thread_2.join
        end.to raise_error(TableLockTimeoutError)

        expect(referential_1).to be_persisted
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
