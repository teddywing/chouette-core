class ModelAttribute
  cattr_reader :all

  @@all = []

  attr_reader :klass, :name, :data_type

  def self.define(klass, name, data_type)
    @@all << new(klass, name, data_type)
  end

  def initialize(klass, name, data_type)
    @klass = klass
    @name = name
    @data_type = data_type
  end
end
