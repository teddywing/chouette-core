module ErrorFormat extend self

    def details error_object
      error_object.errors.messages.map(&partial(:detail, error_object))
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
