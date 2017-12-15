module IntegrationSpecHelper
  def with_permission permission, &block
    context "with permission #{permission}" do
      let(:permissions){ [permission] }
      context('', &block) if block_given?
    end

    def paginate_collection klass, decorator, page=1
      ModelDecorator.decorate( klass.page(page), with: decorator )
    end

    def build_paginated_collection factory, decorator, opts={}
      count = opts.delete(:count) || 2
      page = opts.delete(:page) || 1
      klass = nil
      count.times { klass ||= create(factory, opts).class }
      paginate_collection klass, decorator, page
    end
  end
end

RSpec.configure do |config|
  config.extend IntegrationSpecHelper, type: :view
end

RSpec::Matchers.define :have_link_for_each_item do |collection, name, href|
  match do |actual|
    collection.each do |item|
      expect(rendered).to have_selector("tr.#{TableBuilderHelper.item_row_class_name(collection)}-#{item.id} .actions a[href='#{href.call(item)}']", count: 1)
    end
  end
  description { "have #{name} link for each item" }
end

RSpec::Matchers.define :have_the_right_number_of_links do |collection, count|
  match do |actual|
    collection.each do |item|
      expect(rendered).to have_selector("tr.#{TableBuilderHelper.item_row_class_name(collection)}-#{item.id} .actions a", count: count)
    end
  end
  description { "have #{count} links for each item" }
end
