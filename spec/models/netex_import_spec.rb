RSpec.describe NetexImport do

  subject{ build :netex_import }

  it 'base case' do
    expect_it.to be_valid
  end

  context 'validates presence of' do 
    it 'referential' do
      subject.referential_id = nil
      expect_it.not_to be_valid
    end


    it 'workbench' do
      subject.workbench_id = nil
      expect_it.not_to be_valid
    end
  end
end
