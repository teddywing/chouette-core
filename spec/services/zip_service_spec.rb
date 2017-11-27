RSpec.describe ZipService, type: :zip do

  let( :unzipper ){ described_class.new( zip_data, allowed_lines ) }
  subject { unzipper.subdirs }

  let( :allowed_lines ){ Set.new(%w{C00108 C00109}) }
  let( :zip_data ){ zip_archive.data }
  let( :zip_archive ){ make_zip zip_name, zip_content }

  context 'one, legal, referential' do
    let( :zip_name ){ 'one_referential_ok.zip' }
    let( :zip_content ){ first_referential_ok_data }

    it 'yields correct output' do
      subject.each do | subdir |
        expect_correct_subdir subdir, make_zip('expected.zip', first_referential_ok_data)
      end
    end
  end

  context 'two, legal, referentials' do
    let( :zip_name ){ 'two_referential_ok.zip' }
    let( :zip_content ){ first_referential_ok_data.merge( second_referential_ok_data ) }
    let( :expected_zips ){ [
      make_zip('expected.zip', first_referential_ok_data),
      make_zip('expected.zip', second_referential_ok_data)
    ] }

    it 'yields correct output' do
      subject.zip(expected_zips).each do | subdir, expected_zip |
        expect_correct_subdir subdir, expected_zip
      end
    end
  end

  context 'one referential with a spurious directory' do
    let( :zip_name ){ 'one_referential_spurious.zip' }
    let( :zip_content ){ first_referential_spurious_data }

    it 'returns a not ok object' do
      expect_incorrect_subdir subject.first, expected_spurious: %w{SPURIOUS}
    end
  end

  context 'one referential with a foreign line' do
    let( :zip_name ){ 'one_referential_foreign.zip' }
    let( :zip_content ){ first_referential_foreign_data }

    it 'returns a not ok object' do
      expect_incorrect_subdir subject.first, expected_foreign_lines: %w{C00110}
    end
  end

  context '1st ref ok, 2nd foreign line, 3rd spurious' do
    let( :zip_name ){ '3-mixture.zip' }
    let( :zip_content ){ first_referential_ok_data
                           .merge(first_referential_foreign_data)
                           .merge(first_referential_spurious_data) }

    it 'returns 3 objects accordingly' do
      subdirs = subject.to_a

      expect_correct_subdir subdirs.first, make_zip('expected.zip', first_referential_ok_data)

      expect_incorrect_subdir subdirs.second, expected_foreign_lines: %w{C00110}
      expect_incorrect_subdir subdirs.third,  expected_spurious: %W{SPURIOUS}
    end
  end

  context 'one messed up' do 
    let( :zip_name ){ 'one_messed_up.zip' }
    let( :zip_content ){ messed_up_referential_data }

    it 'returns a not ok object (all error information provided)' do
      expect_incorrect_subdir subject.first,
                                expected_foreign_lines: %w{C00110 C00111},
                                expected_spurious: %w{SPURIOUS1 SPURIOUS2}
    end
    
  end
  # Behaviour
  # ---------
  def expect_correct_subdir subdir, expected_zip 
    expect( subdir ).to be_ok
    expect( subdir.foreign_lines ).to be_empty
    expect( subdir.spurious ).to be_empty
    subdir.stream.tap do | stream |
      stream.rewind
      expect( stream.read ).to eq(expected_zip.data)
    end
  end

  def expect_incorrect_subdir subdir, expected_spurious: [], expected_foreign_lines: []
    expect( subdir ).not_to be_ok
    expect( subdir.foreign_lines ).to eq(expected_foreign_lines)
    expect( subdir.spurious ).to eq(expected_spurious)
  end

  # Data
  # ----
  let :first_referential_ok_data do
    {
       'Referential1/calendriers.xml'     => 'calendriers',
       'Referential1/commun.xml'          => 'common',
       'Referential1/offre_C00108_9.xml'  => 'line 108 ref 1',
       'Referential1/offre_C00109_10.xml' => 'line 109 ref 1'
    }
  end
  let :first_referential_foreign_data do
    {
       'Referential2/calendriers.xml'     => 'calendriers',
       'Referential2/commun.xml'          => 'common',
       'Referential2/offre_C00110_11.xml' => 'foreign line ref 1',
       'Referential2/offre_C00108_9.xml'  => 'line 108 ref 1',
       'Referential2/offre_C00109_10.xml' => 'line 109 ref 1'
    }
  end
  let :first_referential_spurious_data do
    {
       'Referential3/calendriers.xml'     => 'calendriers',
       'Referential3/commun.xml'          => 'common',
       'Referential3/SPURIOUS/commun.xml' => 'common',
       'Referential3/offre_C00108_9.xml'  => 'line 108 ref 1',
       'Referential3/offre_C00109_10.xml' => 'line 109 ref 1'
    }
  end
  let :second_referential_ok_data do
    {
       'Referential4/calendriers.xml'     => 'calendriers',
       'Referential4/commun.xml'          => 'common',
       'Referential4/offre_C00108_9.xml'  => 'line 108 ref 2',
       'Referential4/offre_C00109_10.xml' => 'line 109 ref 2'
    }
  end
  let :messed_up_referential_data do
    {
       'Referential5/calendriers.xml'      => 'calendriers',
       'Referential5/commun.xml'           => 'common',
       'Referential5/SPURIOUS1/commun.xml' => 'common',
       'Referential5/SPURIOUS2/commun.xml' => 'common',
       'Referential5/offre_C00110_11.xml'  => 'foreign line ref 1',
       'Referential5/offre_C00111_11.xml'  => 'foreign line ref 1',
       'Referential5/offre_C00108_9.xml'   => 'line 108 ref 1',
       'Referential5/offre_C00109_10.xml'  => 'line 109 ref 1'
    }
  end


end
