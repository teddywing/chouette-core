class ActiveRecord::Base
  def self.seed_by(key_attribute, &block)
    model = find_or_initialize_by key_attribute
    print "Seed #{name} #{key_attribute.inspect} "
    yield model

    puts "[#{(model.changed? ? 'updated' : 'no change')}]"
    model.save!

    model
  end
end
