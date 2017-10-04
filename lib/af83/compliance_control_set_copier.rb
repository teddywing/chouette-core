module AF83
  # We use a class instead of a singleton object because we will use
  # a cache to avoid copying instancs of ComplianceControl twice as they
  # might be reachable from CCSet **and** its descendent CCBlock.
  # More generally spoken, we copy a DAG, not a tree.
  class ComplianceControlSetCopier

    # Naming Convention: As we are in a domain with quite long names we
    #                    abbreviate compliance_control to cc and
    #                    compliance_check to cck iff used as prefixes.

    attr_reader :cc_set_id, :referential_id

    def copy cc_set_id, referential_id
      @cc_set_id      = cc_set_id
      @referential_id = referential_id
      check_organisation_coherence!
      copy_dag
    end


    private


    # Workers
    # -------
    def check_organisation_coherence!
      return true if cc_set.organisation_id == referential.organisation_id 
      raise ArgumentError, "Incoherent organisation of referential"
    end

    def copy_dag
      # Assure cck_set's existance, just in case cc_set is _empty_.
      cck_set
      make_cck_blocks
      make_ccks_from_ccs
    end

    def make_all_cck_block_children cc_block, cck_block
      cc_block
        .compliance_controls
        .each{ |compliance_control| make_compliance_check(compliance_control, cck_block.id) } 
    end
    def make_cck_block cc_block
      cck_block =
        cck_set.compliance_check_blocks.create(
          name: name_with_refid(cc_block.name))

      make_all_cck_block_children cc_block, cck_block
    end
    def make_cck_blocks
      cc_set.compliance_control_blocks.each(&method(:make_cck_block))
    end

    def make_ccks_from_ccs
      cc_set.compliance_controls.each(&method(:make_compliance_check))
    end

    def make_compliance_check(compliance_control, cck_block_id = nil)
      already_there = get_from_cache compliance_control.id
      # We do not want to impose traversal order of the DAG, that would
      # make the code more resistant to change...
      # So we check if we need to update the compliance_check_block_id
      # of a control found in the cache.
      # N.B. By traversing the indirect descendents from a set first,
      #      or IOW, traversing the control_blocks before the controls,
      #      this check could go away and we could return from the
      #      method in case of a cache hit.
      if already_there
        # Purely defensive:
        if already_there.compliance_check_block_id.nil? && cck_block_id
          already_there.update compliance_check_block_id: cck_block_id
        end
        return
      end
      make_compliance_check!(compliance_control, cck_block_id)
    end
    def make_compliance_check!(compliance_control, cck_block_id)
      add_to_cache(
        compliance_control.id,
        cck_set.compliance_checks.create(
          criticity: compliance_control.criticity,
          name: name_with_refid(compliance_control.name),
          code: compliance_control.code,
          origin_code: compliance_control.origin_code,
          compliance_check_block_id: cck_block_id
        ))
    end

    def name_with_refid name
      [name, referential.name].join('-')
    end

    # Lazy Values
    # -----------
    def cc_set
      @__cc_set__ ||= ComplianceControlSet.find(cc_set_id)
    end
    def cck_set
      @__cck_set__ ||= ComplianceCheckSet.create!(
        compliance_control_set_id: cc_set_id,
        referential_id: referential_id,
        workbench_id: referential.workbench_id,
        name: name_with_refid(cc_set.name),
        status: 'new'
      )
    end
    def referential
      @__referential__ ||= Referential.find(referential_id)
    end

    # Copy Cache
    # ----------
    def add_to_cache key, obj
      # Right now we map key -> obj, in case memory consumption becomes too important
      # we can map key -> obj.id and fetch the object from the database in get_from_cache
      # (time vs. space tradeoff)
      copy_cache.merge!(key => obj)
    end
    def get_from_cache key
      copy_cache[key].tap do | ele |
      end
    end
    def copy_cache
      @__copy_cache__ ||= Hash.new
    end
  end
end
