RSpec.describe Referential, type: :model do
  let (:workbench) { create(:workbench) }

  def with_a_mutual_lock timeout: false
    @with_a_mutual_lock = true
    yield
    thread_1 = Thread.new do
      ActiveRecord::Base.transaction do
        # seize LOCK
        @locking_thread_content.try :call
        sleep 10
        # release LOCK
      end
    end

    thread_2 = Thread.new do
      sleep 5
      ActiveRecord::Base.transaction do
        if timeout
          ActiveRecord::Base.connection.execute "SET lock_timeout = '1s'"
        end
        # waits for LOCK, (because of sleep 5)
        @waiting_thread_content.try :call
        # when lock was eventually obtained validation failed
      end
    end

    thread_1.join
    if timeout
      expect do
        thread_2.join
      end.to raise_error(TableLockTimeoutError)
    else
      thread_2.join
    end
    @locking_thread_content = nil
    @waiting_thread_content = nil
    @with_a_mutual_lock = false
  end

  def locking_thread
    raise "this method is intended to be called inside a `with_a_mutual_lock`" unless @with_a_mutual_lock
    @locking_thread_content = yield
  end

  def waiting_thread
    @waiting_thread_content = yield
  end

  context "when two identical Referentials are created, only one is saved" do
    it "works synchronously" do
      referential_1 = build(
        :referential,
        workbench: workbench,
        organisation: workbench.organisation
      )
      referential_2 = referential_1.dup
      referential_2.slug = "#{referential_1.slug}_different"

      metadata_1 = build(:referential_metadata, referential: nil)
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

        with_a_mutual_lock do
          locking_thread do
            referential_1.save
          end
          waiting_thread do
            referential_2.save
            referential_3 = create(:referential)
          end
        end

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
        with_a_mutual_lock do
          locking_thread do
            referential_1.metadatas_attributes = [metadata_1.attributes]
            referential_1.save
          end
          waiting_thread do
            referential_2.metadatas_attributes = [metadata_2.attributes]
            referential_2.save
          end
        end

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
        with_a_mutual_lock timeout: true do
          locking_thread do
            referential_1.save
          end
          waiting_thread do
            referential_2.save
            referential_3 = create(:referential)
          end
        end

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
