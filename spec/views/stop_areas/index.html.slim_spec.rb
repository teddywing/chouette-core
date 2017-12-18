require 'spec_helper'

RSpec::Matchers.define :have_link_for_each_stop_area do |stop_areas, name, href|
  match do |actual|
    stop_areas.each do |stop_area|
      expect(rendered).to have_selector("tr.stoparea-#{stop_area.id} .actions a[href='#{href.call(stop_area)}']", count: 1)
    end
  end
  description { "have #{name} link for each stop area" }
end

RSpec::Matchers.define :have_the_right_number_of_links do |stop_areas, count|
  match do |actual|
    stop_areas.each do |stop_area|
      expect(rendered).to have_selector("tr.stoparea-#{stop_area.id} .actions a", count: count)
    end
  end
  description { "have #{count} links for each stop area" }
end

describe "/stop_areas/index", :type => :view do

  let!(:stop_area_referential) { assign :stop_area_referential, create(:stop_area_referential) }
  let!(:stop_areas) do
    2.times { create(:stop_area, stop_area_referential: stop_area_referential) }
    assign :stop_areas, ModelDecorator.decorate( Chouette::StopArea.page(1), with: StopAreaDecorator )
  end
  let!(:q) { assign :q, Ransack::Search.new(Chouette::StopArea) }

  before :each do
    allow(view).to receive(:link_with_search).and_return("#")
    allow(view).to receive(:collection).and_return(stop_areas)
    allow(view).to receive(:current_referential).and_return(stop_area_referential)
    controller.request.path_parameters[:stop_area_referential_id] = stop_area_referential.id
    render
  end

  it { should have_link_for_each_stop_area(stop_areas, "show", -> (stop_area){ view.stop_area_referential_stop_area_path(stop_area_referential, stop_area) }) }
  it { should have_the_right_number_of_links(stop_areas, 1) }

  with_permission "stop_areas.create" do
    it { should have_link_for_each_stop_area(stop_areas, "show", -> (stop_area){ view.stop_area_referential_stop_area_path(stop_area_referential, stop_area) }) }
    it { should have_link_for_each_stop_area(stop_areas, "create", -> (stop_area){ view.new_stop_area_referential_stop_area_path(stop_area_referential) }) }
    it { should have_the_right_number_of_links(stop_areas, 2) }
  end

  with_permission "stop_areas.update" do
    it { should have_link_for_each_stop_area(stop_areas, "show", -> (stop_area){ view.stop_area_referential_stop_area_path(stop_area_referential, stop_area) }) }
    it { should have_link_for_each_stop_area(stop_areas, "edit", -> (stop_area){ view.edit_stop_area_referential_stop_area_path(stop_area_referential, stop_area) }) }
    it { should have_the_right_number_of_links(stop_areas, 2) }
  end

end
