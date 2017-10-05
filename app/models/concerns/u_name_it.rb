module UNameIt
  # Options as e.g. different key names and options for each
  # belongs_to can be defined on an AS NEEDED basis...
  def belongs_to_through_if( grand_parent_klass_sym,
                            parent:, 
                            as: )
    belongs_to grand_parent_klass_sym
    validates grand_parent_klass_sym, presence: true
    belongs_to parent

    validate do
      parent_instance = send(parent)
      unless parent_instance.nil?

        direct_grand_parent_id   = self["#{grand_parent_klass_sym}_id"]
        indirect_grand_parent_id = parent_instance["#{grand_parent_klass_sym}_id"]
        unless direct_grand_parent_id == indirect_grand_parent_id

          errors.add(
            as,
            I18n.t([self.class.name.underscore.pluralize, 'errors', as].join('.'),
                   direct_id: direct_grand_parent_id,
                   indirect_id: indirect_grand_parent_id))
        end
      end
    end
  end

end
