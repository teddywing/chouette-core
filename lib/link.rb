class Link
  attr_reader :content, :href, :method, :data

  def initialize(content: nil, href:, method: nil, data: nil)
    @content = content
    @href = href
    @method = method
    @data = data
  end
end
