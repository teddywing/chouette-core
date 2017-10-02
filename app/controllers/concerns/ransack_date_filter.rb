module RansackDateFilter
  extend ActiveSupport::Concern
  cattr_accessor :date_param

    included do

      def set_date_time_params
        start_date = []
        end_date = []

        if params[:q] && params[:q][@@date_param] && !params[:q][@@date_param].has_value?(nil) && !params[:q][@@date_param].has_value?("")
          [1, 2, 3].each do |key|
            start_date <<  params[:q][@@date_param]["start_date(#{key}i)"].to_i
            end_date <<  params[:q][@@date_param]["end_date(#{key}i)"].to_i
          end
        params[:q].delete([@@date_param])

        if @@klass == DateTime
          @begin_range = @@klass.new(*start_date,0,0,0) rescue nil
          @end_range = @@klass.new(*end_date,23,59,59) rescue nil
        else
          @begin_range = @@klass.new(*start_date) rescue nil
          @end_range = @@klass.new(*end_date) rescue nil
        end
      end

      # Fake ransack filter
      def ransack_period_range **options
        return options[:scope] unless !!@begin_range && !!@end_range

        if @begin_range > @end_range
          flash.now[:error] = options[:error_message]
        else
          scope = options[:scope].send options[:query], @begin_range..@end_range
        end
        scope
      end
    end

    def self.set_date_param(param_name, klass)
      @@date_param = param_name
      @@klass = klass
    end
    
    private_class_method :set_date_param

  end
end