class Link
  attr_reader :name, :href, :method, :data

  def initialize(name: nil, href:, method: nil, data: nil)
    @name = name
    @href = href
    @method = method
    @data = data
  end
end
