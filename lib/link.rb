class Link
  attr_reader :name, :href, :method, :data

  def initialize(name: nil, href:, method: :get, data: nil)
    @name = name
    @href = href
    @method = method
    @data = data
  end
end
