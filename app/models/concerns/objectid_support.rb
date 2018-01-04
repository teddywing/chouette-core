module ObjectidSupport
  extend ActiveSupport::Concern

  included do
    before_validation :before_validation_objectid, unless: Proc.new {|model| model.read_attribute(:objectid)}
    after_commit :after_commit_objectid, on: :create, if: Proc.new {|model| model.read_attribute(:objectid).try(:include?, '__pending_id__')}
    validates_presence_of :objectid
    validates_uniqueness_of :objectid, skip_validation: Proc.new {|model| model.read_attribute(:objectid).nil?}

    if respond_to?(:ransacker)
      class <<self
        def search_with_referential referential: nil, **args
          out = search_without_referential(args)
          if referential
            out.base.conditions.each_with_index do |cond, i|
              if cond.attributes.first.name == "short_id"
                new_cond = Ransack::Nodes::Condition.new(cond.context)
                new_cond.attributes = { 0 => {
                  name: "short_id",
                  ransacker_args: [referential]
                }}
                new_cond.predicate = cond.predicate
                new_cond.values = cond.values.map(&:value)
                out.base.conditions[i] = new_cond
              end
            end
          end
          out
        end
        alias_method_chain :search, :referential
      end

      ransacker :short_id, args: [:parent, :ransacker_args] do |parent, args|
        referential = args[0]
        type = referential&.objectid_formatter&.class.try(:short_id_type)
        type ||= "text"
        Arel.sql("objectid_short_id_as_#{type}(objectid)")
      end
    end

    def before_validation_objectid
      self.referential.objectid_formatter.before_validation self
    end

    def after_commit_objectid
      self.referential.objectid_formatter.after_commit self
    end

    def get_objectid
      self.referential.objectid_formatter.get_objectid read_attribute(:objectid) if self.referential.objectid_format && read_attribute(:objectid)
    end

    def objectid
      get_objectid.try(:to_s)
    end

    def objectid_class
      get_objectid.try(:class)
    end
  end
end
