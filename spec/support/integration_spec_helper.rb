module IntegrationSpecHelper

  def paginate_collection klass, decorator, page=1
    coll = klass.page(page)
    if decorator
      coll = ModelDecorator.decorate( coll, with: decorator )
    end
    coll
  end

  def build_paginated_collection factory, decorator, opts={}
    count = opts.delete(:count) || 2
    page = opts.delete(:page) || 1
    klass = nil
    count.times { klass ||= create(factory, opts).class }
    paginate_collection klass, decorator, page
  end

  module Methods
    def with_permission permission, &block
      context "with permission #{permission}" do
        let(:permissions){ [permission] }
        context('', &block) if block_given?
      end
    end
  end

  def self.included into
    into.extend Methods
  end
end

RSpec.configure do |config|
  config.include IntegrationSpecHelper, type: :view
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
