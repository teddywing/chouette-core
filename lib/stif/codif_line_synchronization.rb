module Stif
  module CodifLineSynchronization
    class << self
      # Don't check last synchronizations date and lines last update if first_sync
      def synchronize first_sync = false
        # Check last synchronization and synchronization interval
        date = DateTime.now.to_date - LineReferential.first.sync_interval.days
        last_sync = LineReferential.first.line_referential_sync.line_sync_operations.last.try(:created_at)
        return if (last_sync.nil? || last_sync.to_date > date) && !first_sync
        
        # TODO Check exceptions and status messages
        begin
          # Fetch Codifline operators and lines
          client    = Codifligne::API.new
          operators = client.operators
          lines = client.lines

          operators.map{ |o| create_or_update_company(o) }
          lines.map{ |l| create_or_update_line(l) if first_sync || l.instance_variable_get(:@updated_at).to_date > last_sync.to_date}
          
          delete_deprecated_companies(operators)
          deactivate_deprecated_lines(lines)

          LineReferential.first.line_referential_sync.record_status "OK"
        rescue Exception => e
          ap e.message
          LineReferential.first.line_referential_sync.record_status "Error"
        end
      end

      def create_or_update_company(api_operator)
        params = {
          name: api_operator.name,
          objectid: api_operator.stif_id
        }
        company = save_or_update(params, Chouette::Company)
      end

      def create_or_update_line(api_line)
        params = {
          name: api_line.name,
          objectid: api_line.stif_id,
          number: api_line.short_name,
          deactivated: false
        }
        
        # Find Company
        # TODO Check behavior when operator_codes count is 0 or > 1
        if api_line.operator_codes.any?
          company_id = "STIF:CODIFLIGNE:Operator:" + api_line.operator_codes.first
          params[:company] = Chouette::Company.find_by(objectid: company_id)
        end

        save_or_update(params, Chouette::Line)
      end

      def delete_deprecated_companies(operators)
        ids = operators.map{ |o| o.stif_id }.to_a
        Chouette::Company.where.not(objectid: ids).destroy_all
      end

      def deactivate_deprecated_lines(lines)
        ids = lines.map{ |l| l.stif_id }.to_a
        Chouette::Line.where.not(objectid: ids).map { |l| l.deactivated = true ; l.save }
      end

      def save_or_update(params, klass)
        params[:line_referential] = LineReferential.first
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