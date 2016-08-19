module Stif
  module CodifLineSynchronization
    class << self
      # Don't check last synchronizations if force_sync
      def synchronize force_sync = false
        # Check last synchronization and synchronization interval
        date = DateTime.now.to_date - LineReferential.first.sync_interval.days
        last_sync = LineReferential.first.line_referential_sync.line_sync_operations.where(status: :ok).last.try(:created_at)
        return if last_sync.present? && last_sync.to_date > date && !force_sync
        
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :second)
        # TODO Check exceptions and status messages
        begin
          # Fetch Codifline data
          client = Codifligne::API.new
          operators       = client.operators
          lines           = client.lines
          networks        = client.networks
          groups_of_lines = client.groups_of_lines

          operators.map       { |o| create_or_update_company(o) }
          lines.map           { |l| create_or_update_line(l) }
          networks.map        { |n| create_or_update_network(n) }
          groups_of_lines.map { |g| create_or_update_group_of_lines(g) }
          
          total_deleted = delete_deprecated(operators, Chouette::Company)
          total_deleted += delete_deprecated_lines(lines)
          total_deleted += delete_deprecated(networks, Chouette::Network)
          total_deleted += delete_deprecated(groups_of_lines, Chouette::GroupOfLine)

          # Building log message
          total_codifligne_elements = operators.count + lines.count + networks.count + groups_of_lines.count
          total_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :second) - start_time

          LineReferential.first.line_referential_sync.record_status :ok, I18n.t('synchronization.message.success', time: total_time, imported: total_codifligne_elements, deleted: total_deleted)
        rescue Exception => e
          Rails.logger.error "#{e} #{e.backtrace}"

          total_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :second) - start_time
          LineReferential.first.line_referential_sync.record_status :ko, I18n.t('synchronization.message.failure', time: total_time)
        end
      end

      def create_or_update_company(api_operator)
        params = {
          name: api_operator.name,
          objectid: api_operator.stif_id,
          import_xml: api_operator.xml
        }
        save_or_update(params, Chouette::Company)
      end

      def create_or_update_line(api_line)
        params = {
          name: api_line.name,
          objectid: api_line.stif_id,
          number: api_line.short_name,
          deactivated: (api_line.status == "inactive" ? true : false),
          import_xml: api_line.xml
        }
        
        # Find Company
        # TODO Check behavior when operator_codes count is 0 or > 1
        if api_line.operator_codes.any?
          company_id = "STIF:CODIFLIGNE:Operator:" + api_line.operator_codes.first
          params[:company] = Chouette::Company.find_by(objectid: company_id)
        end

        save_or_update(params, Chouette::Line)
      end

      def create_or_update_network(api_network)
        params = {
          name: api_network.name,
          objectid: api_network.stif_id,
          import_xml: api_network.xml
        }

        # Find Lines
        params[:lines] = []
        api_network.line_codes.each do |line|
          line_id = "STIF:CODIFLIGNE:Line:" + line
          params[:lines] << Chouette::Line.find_by(objectid: line_id)
        end

        save_or_update(params, Chouette::Network)
      end

      def create_or_update_group_of_lines(api_group_of_lines)
        params = {
          name: api_group_of_lines.name,
          objectid: api_group_of_lines.stif_id,
          import_xml: api_group_of_lines.xml
        }

        # Find Lines
        params[:lines] = []
        api_group_of_lines.line_codes.each do |line|
          line_id = "STIF:CODIFLIGNE:Line:" + line
          # TODO : handle when lines doesn't exist
          chouette_line = Chouette::Line.find_by(objectid: line_id)
          params[:lines] << chouette_line if chouette_line.present?
        end

        save_or_update(params, Chouette::GroupOfLine)
      end

      def delete_deprecated(objects, klass)
        ids = objects.map{ |o| o.stif_id }.to_a
        deprecated = klass.where.not(objectid: ids)
        count = deprecated.count
        deprecated.destroy_all
        count
      end

      def delete_deprecated_lines(lines)
        ids = lines.map{ |l| l.stif_id }.to_a
        deprecated = Chouette::Line.where.not(objectid: ids).where(deactivated: false)
        count = deprecated.count
        deprecated.map { |l| l.deactivated = true ; l.save }
        count
      end

      def save_or_update(params, klass)
        params[:line_referential] = LineReferential.first unless klass == Chouette::Network
        object = klass.where(objectid: params[:objectid]).first
        if object
          object.assign_attributes(params)
          object.save if object.changed?
        else
          object = klass.new(params)
          object.save if object.valid?
        end
        object
      end
    end
  end
end