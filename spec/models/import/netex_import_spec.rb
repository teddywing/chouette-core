RSpec.describe NetexImport, type: :model do


  context 'with referential' do
    it 'will trigger the Java API' do

    end
  end

  context 'without referential' do
    subject { build :netex_import, referential_id: nil }

    it 'is aborted if it does not have a referential' do
      require 'pry'; binding.pry


    end

    it 'will not trigger the Java API' do

    end

  end

end
