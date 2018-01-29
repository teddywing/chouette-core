module RansackDateFilter
  extend ActiveSupport::Concern

  included do

    def begin_range_var prefix
      "@#{[prefix, "begin_range"].compact.join('_')}"
    end

    def end_range_var prefix
      "@#{[prefix, "end_range"].compact.join('_')}"
    end

    def set_date_time_params(param_name, klass, prefix: nil)
      start_date = []
      end_date = []

      if params[:q] && params[:q][param_name] && !params[:q][param_name].has_value?(nil) && !params[:q][param_name].has_value?("")
        [1, 2, 3].each do |key|
          start_date <<  params[:q][param_name]["start_date(#{key}i)"].to_i
          end_date <<  params[:q][param_name]["end_date(#{key}i)"].to_i
        end

        params[:q].delete([param_name])

        if klass == DateTime
          instance_variable_set begin_range_var(prefix), klass.new(*start_date,0,0,0) rescue nil
          instance_variable_set end_range_var(prefix), klass.new(*end_date,23,59,59) rescue nil
        else
          instance_variable_set begin_range_var(prefix), klass.new(*start_date) rescue nil
          instance_variable_set end_range_var(prefix), klass.new(*end_date) rescue nil
        end
      end
    end

    # Fake ransack filter
    def ransack_period_range **options
      prefix = options[:prefix]
      return options[:scope] unless !!instance_variable_get(begin_range_var(prefix)) && !!instance_variable_get(end_range_var(prefix))

      scope = options[:scope]
      if instance_variable_get(begin_range_var(prefix)) > instance_variable_get(end_range_var(prefix))
        flash.now[:error] = options[:error_message]
      else
        scope = scope.send options[:query], instance_variable_get(begin_range_var(prefix))..instance_variable_get(end_range_var(prefix))
      end
      scope
    end
  end

end
