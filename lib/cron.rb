module Cron
  class << self

    def sync_organizations
      Organisation.portail_sync
    end

    def sync_users
      User.portail_sync
    end

    def sync_reflex
      begin
        sync = StopAreaReferential.find_by(name: 'Reflex').stop_area_referential_syncs.build
        raise "reflex:sync aborted - There is already an synchronisation in progress" unless sync.valid?
        sync.save if sync.valid?
      rescue => e
        Rails.logger.warn(e.message)
      end
    end

    def sync_codifligne
      begin
        sync = LineReferential.find_by(name: 'CodifLigne').line_referential_syncs.build
        raise "Codifligne:sync aborted - There is already an synchronisation in progress" unless sync.valid?
        sync.save if sync.valid? 
      rescue => e
        Rails.logger.warn(e.message)
      end
    end

    def check_import_operations
      begin
        ParentNotifier.new(ComplianceCheckSet).notify_when_finished
        ComplianceCheckSet.abort_old
      rescue => e
        Rails.logger.error(e.inspect)
      end
    end

    def check_ccset_operations
      begin
        ParentNotifier.new(Import::Base).notify_when_finished
        Import::Netex.abort_old
      rescue => e
        Rails.logger.error(e.inspect)
      end
    end
  end
end