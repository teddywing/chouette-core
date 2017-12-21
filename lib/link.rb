class Link
  attr_reader :content, :href, :method, :data, :extra_class

  def initialize(content: nil, href:, method: nil, data: nil, extra_class: nil)
    @content = content
    @href = href
    @method = method
    @data = data
    @extra_class = extra_class
  end
end
