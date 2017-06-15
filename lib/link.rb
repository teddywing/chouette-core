class Link
  attr_reader :name, :href, :method, :data, :content

  def initialize(name: nil, href:, method: nil, data: nil, content: nil)
    @name = name
    @href = href
    @method = method
    @data = data
    @content = content
  end
end
