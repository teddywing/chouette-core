module StoredProcedures extend self

  def invoke_stored_procedure(name, *params)
    name = name.to_s
    raise ArgumentError, "no such stored procedure #{name.inspect}" unless stored_procedures[name]
    invocation = "#{name}(#{quote_params(params)})"
    ActiveRecord::Base.connection.execute "SELECT #{invocation}" 
  end

  def create_stored_procedure(name)
    name = name.to_s
    sql_file = File.expand_path("../../sql/#{name}.sql", __FILE__)
    raise ArgumentError, "missing sql file #{sql_file.inspect}" unless File.readable? sql_file

    # We could store the file's content for reload without application restart if desired.
    stored_procedures[name] = true

    ActiveRecord::Base.connection.execute File.read(sql_file)
  end

  private
  def quote_params(params)
    params
      .map(&method(:quote_param))
      .join(", ")
  end

  def quote_param(param)
    case param
    when String
      "'#{param}'"
    when TrueClass
      "'t'"
    when FalseClass
      "'f'"
    else
      param
    end
  end

  def stored_procedures
     @__stored_procedures__ ||= {}
  end
end
