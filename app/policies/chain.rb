module Policies
  # Implements the `chain_policies` macro as follows
  #
  #    chain_policies <method_chain>, policies:
  #
  # e.g.
  #
  #    chain_policies [:archived?, :!], policies: %i{create? edit?}
  #
  # which would establish a precondition `not archived` for the `create?` and `edit?`
  # method, it is semantically identical to instrumenting both methods
  # as follows:
  #    
  #    def create? # or edit?
  #       archived?.! && <original code of method>
  #    end
  module Chain

    # A local chain store implemented to avoid any possible side effect on client policies.
    defined_chains = {}

    # Using `define_method` in order to close over `defined_chains`
    # We need to store the chains because the methods they will apply to
    # are not defined yet.
    define_method :chain_policies do |*conditions, policies:|
      policies.each do | meth_name |
        # self represents the client Policy
        defined_chains[[self, meth_name]] = conditions
      end
    end
    # Intercept method definition and check if a policy_chain has been registered for it‥.
    define_method :method_added do |meth_name, *args, &blk|
      # Delete potentially registered criteria conditions to‥.
      # (i) protect against endless recursion via (:merthod_added → :define_method → :method_added → ‥.
      # (ii) get the condition
      conditions = defined_chains.delete([self, meth_name])
      return unless conditions

      instrument_method(meth_name, conditions)
    end

    private

    # Access to the closure is not necessary anymore, normal metaprogramming can take place :)
    def instrument_method(meth_name, conditions)
      orig_method = instance_method(meth_name)
      # In case of warnings remove original method here, depends on Ruby Version, ok in 2.3.1
      define_method meth_name do |*a, &b|
        # Method chain describing the chained policy precondition.
        conditions.inject(self) do | result, msg |
          result.send msg
        end &&
        orig_method.bind(self).(*a, &b)
      end
    end
  end
end
