module ErrorFormat extend self

  def details error_object
    error_object.errors.messages.inject({}) do |hash, error|
      hash.merge(partial(:detail, error_object, error).call)
    end
  end

  private

  def detail error_object, error
    {
      error.first => {
        error: error.last.first,
        value: error_object[error.first]
      }
    }
  end

  def partial name, *partial_args
    -> *lazy_args do
      send(name, *(partial_args + lazy_args))
    end
  end

end
