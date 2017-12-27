class Chouette::AreaType
  include Comparable

  ALL = %i(zdep zder zdlp zdlr lda).freeze

  @@all = ALL
  mattr_accessor :all

  def self.all=(values)
    @@all = ALL & values
    reset_caches!
  end

  @@instances = {}
  def self.find(code)
    code = code.to_sym
    @@instances[code] ||= new(code) if ALL.include? code
  end

  def self.reset_caches!
    @@instances = {}
    @@options = nil
  end

  def self.options
    @@options ||= all.map { |c| find(c) }.map { |t| [ t.label, t.code ] }
  end

  attr_reader :code
  def initialize(code)
    @code = code
  end

  def <=>(other)
    all.index(code) <=> all.index(other.code)
  end

  def label
    I18n.translate code, scope: 'area_types.label'
  end

end
