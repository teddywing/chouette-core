require 'spec_helper'

describe Chouette::TridentActiveRecord, :type => :model do

  it { expect(Chouette::TridentActiveRecord.ancestors).to include(Chouette::ActiveRecord) }

  subject { create(:time_table) }

  describe "#uniq_objectid" do

    it "should rebuild objectid" do
      tm = create(:time_table)
      tm.objectid = subject.objectid
      tm.uniq_objectid
      expect(tm.objectid).to eq(subject.objectid+"_1")
    end

    it "should rebuild objectid" do
      tm = create(:time_table)
      tm.objectid = subject.objectid
      tm.uniq_objectid
      tm.save
      tm = create(:time_table)
      tm.objectid = subject.objectid
      tm.uniq_objectid
      expect(tm.objectid).to eq(subject.objectid+"_2")
    end

  end

  def create_object(options = {})
    options = {name: "merge1"}.merge options
    attributes = { comment: options[:name], objectid: options[:objectid] }
    Chouette::TimeTable.new attributes
  end

  describe "#prepare_auto_columns" do

    it "should left objectid" do
      tm = create_object :objectid => "first:Timetable:merge1"
      tm.prepare_auto_columns
      expect(tm.objectid).to eq("first:Timetable:merge1")
    end

    it "should add pending_id to objectid" do
      tm = create_object
      tm.prepare_auto_columns
      expect(tm.objectid.start_with?("first:Timetable:__pending_id__")).to be_truthy
    end

    it "should set id to objectid" do
      tm = create_object
      tm.save
      expect(tm.objectid).to eq("first:Timetable:"+tm.id.to_s)
    end

    it "should detect objectid conflicts" do
      tm = create_object
      tm.save
      tm.objectid = "first:Timetable:"+(tm.id+1).to_s
      tm.save
      tm = create_object
      tm.save
      expect(tm.objectid).to eq("first:Timetable:"+tm.id.to_s+"_1")
    end

  end

  describe "objectid" do

    it "should build automatic objectid when empty" do
      g1 = create_object
      g1.save
      expect(g1.objectid).to eq("first:Timetable:"+g1.id.to_s)
    end

    it "should build automatic objectid with fixed when only suffix given" do
      g1 = create_object
      g1.objectid = "toto"
      g1.save
      expect(g1.objectid).to eq("first:Timetable:toto")
    end

    it "should build automatic objectid with extension when already exists" do
      g1 = create_object
      g1.save
      cnt = g1.id + 1
      g1.objectid = "first:Timetable:"+cnt.to_s
      g1.save
      g2 = create_object
      g2.save
      expect(g2.objectid).to eq("first:Timetable:"+g2.id.to_s+"_1")
    end

    it "should build automatic objectid with extension when already exists" do
      g1 = create_object
      g1.save
      cnt = g1.id + 2
      g1.objectid = "first:Timetable:"+cnt.to_s
      g1.save
      g2 = create_object
      g2.objectid = "first:Timetable:"+cnt.to_s+"_1"
      g2.save
      g3 = create_object
      g3.save
      expect(g3.objectid).to eq("first:Timetable:"+g3.id.to_s+"_2")
    end

    it "should build automatic objectid when id cleared" do
      g1 = create_object
      g1.objectid = "first:Timetable:xxxx"
      g1.save
      g1.objectid = nil
      g1.save
      expect(g1.objectid).to eq("first:Timetable:"+g1.id.to_s)
    end
  end

end
