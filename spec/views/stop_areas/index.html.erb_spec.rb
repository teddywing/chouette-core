require 'spec_helper'

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

  it "should render a row for each group" do
    stop_areas.each do |stop_area|
      expect(rendered).to have_selector("tr.stoparea-#{stop_area.id}", count: 1)
    end
  end

  it "should render a show link for each group" do
    stop_areas.each do |stop_area|
      expect(rendered).to have_selector("tr.stoparea-#{stop_area.id} .actions a[href='#{view.stop_area_referential_stop_area_path(stop_area_referential, stop_area)}']", count: 1)
    end
  end

  it "should render no other link for each group" do
    stop_areas.each do |stop_area|
      expect(rendered).to have_selector("tr.stoparea-#{stop_area.id} .actions a", count: 1)
    end
  end

  with_permission "stop_areas.create" do
    it "should render a show link for each group" do
      stop_areas.each do |stop_area|
        expect(rendered).to have_selector("tr.stoparea-#{stop_area.id} .actions a[href='#{view.stop_area_referential_stop_area_path(stop_area_referential, stop_area)}']", count: 1)
      end
    end

    it "should render a create link for each group" do
      stop_areas.each do |stop_area|
        expect(rendered).to have_selector("tr.stoparea-#{stop_area.id} .actions a[href='#{view.new_stop_area_referential_stop_area_path(stop_area_referential)}']", count: 1)
      end
    end

    it "should render no other link for each group" do
      stop_areas.each do |stop_area|
        expect(rendered).to have_selector("tr.stoparea-#{stop_area.id} .actions a", count: 2)
      end
    end
  end

  with_permission "stop_areas.update" do
    it "should render a show link for each group" do
      stop_areas.each do |stop_area|
        expect(rendered).to have_selector("tr.stoparea-#{stop_area.id} .actions a[href='#{view.stop_area_referential_stop_area_path(stop_area_referential, stop_area)}']", count: 1)
      end
    end

    it "should render a edit link for each group" do
      stop_areas.each do |stop_area|
        expect(rendered).to have_selector("tr.stoparea-#{stop_area.id} .actions a[href='#{view.edit_stop_area_referential_stop_area_path(stop_area_referential, stop_area.id)}']", count: 1)
      end
    end

    it "should render no other link for each group" do
      stop_areas.each do |stop_area|
        expect(rendered).to have_selector("tr.stoparea-#{stop_area.id} .actions a", count: 2)
      end
    end
  end

end
