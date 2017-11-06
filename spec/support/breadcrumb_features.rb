module BreadcrumbFeatures
  def expect_breadcrumb_links *link_names 
    within('.breadcrumbs') do
      all('a').zip( link_names ).each do | link_element, link_content |
        within(link_element) do |  |
          expect(page).to have_content(link_content)
        end
      end
    end
  end
end

RSpec.configure do | conf |
  conf.include BreadcrumbFeatures, type: :feature
end
