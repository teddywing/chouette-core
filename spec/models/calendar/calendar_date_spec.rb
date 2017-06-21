RSpec.describe Calendar::CalendarDate do

  subject { described_class.new(year, month, day) }
  let( :year ){ 2000 }
  let( :month ){ 2 }
  
  let( :str_repr ){ %r{#{year}-0?#{month}-0?#{day}} }



  shared_examples_for "date accessors" do
    it "accesses year" do
      expect( subject.year ).to eq(year)
    end
    it "accesses month" do
      expect( subject.month ).to eq(month)
    end
    it "accesses day" do
      expect( subject.day ).to eq(day)
    end
    it "converts to a string" do
      expect( subject.to_s ).to match(str_repr)
    end
  end

  context 'legal' do 
    let( :day ){ 29 }
    it { expect_it.to be_legal }
    it_should_behave_like "date accessors"
  end

  context 'illegal' do 
    let( :day ){ 30 }
    it { expect_it.not_to be_legal }
    it_should_behave_like "date accessors"
  end
  
end
