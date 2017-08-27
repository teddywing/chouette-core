RSpec.describe ZipService do
  describe 'Regression Issue # 4273 https://projects.af83.io/issues/4273' do
    let( :zip_service ){ described_class }
    let( :unzipper ){ zip_service.new(zip_data) }
    let( :zip_data ){ File.read zip_file }

    context 'real test data' do
      let( :subdir_names ){ %w<OFFRE_TRANSDEV_20170301122517 OFFRE_TRANSDEV_20170301122519>  }
      let( :expected_chksums ){
        checksum_trees( subdir_names.map{ |sn| subdir_file(sn, prefix: 'source_') } )
      }

      let( :zip_file ){ fixtures_path 'OFFRE_TRANSDEV_2017030112251.zip' }
      #
      # Remove potential test artefacts
      before do
        subdir_names.each do | subdir_name |
          File.unlink( subdir_file subdir_name, suffix: '.zip' ) rescue nil
          Dir.unlink( subdir_file subdir_name ) rescue nil
        end
      end

      it "yields the correct content" do
        subdir_contents = {}
        # Write ZipService Streams to files and inflate them to file system
        unzipper.subdirs.each do | subdir |
          File.open(subdir_file( subdir.name, suffix: '.zip' ), 'wb'){ |f| f.write subdir.stream.string }
          unzip_subdir subdir
        end
        # Represent the inflated file_system as a checksum tree
        actual_checksums = 
          checksum_trees( subdir_names.map{ |sn| subdir_file(sn, prefix: 'target/') } )
        expect( actual_checksums ).to eq( expected_chksums )
      end

    end

  end

  def checksum_trees *dirs
    dirs.flatten.inject({},&method(:checksum_tree))
  end
  def checksum_tree repr, dir
    Dir.glob("#{dir}/**/*").each do |file|
      if !File.directory?(file)
        repr.merge!( File.basename(file) => %x{cksum #{file}}.split.first ){ |_, ov, nv| Array(ov) << nv }
      end
    end
    repr
  end

  def subdir_file( subdir, prefix: 'target_', suffix: '' )
    fixtures_path("#{prefix}#{subdir}#{suffix}")
  end

  def unzip_subdir subdir
    %x{unzip -oqq #{subdir_file subdir.name, suffix: '.zip'} -d #{fixture_path}/target}
  end
end
