# Convenience meta spec to debug potential bugs in zip support helpers
# uncomment run and check files in `zip_fixtures_path`
#
# It also describes what the two helpers do and therefore facilitates the usage of 
#
#   * `make_zip` and
#   * `make_zip_from_tree
# 
RSpec.describe 'ZipData', type: [:zip, :meta] do

  # let( :zip_file ){ zip_fixtures_path('xxx.zip') }
  # let( :tmp_output ){ zip_fixtures_path('tmp') }

  # before do
  #   clear_all_zip_fixtures!
  #   Dir.mkdir(tmp_output)
  # end

  # context 'a simple archive' do
  #   let( :zip_data ){ make_zip "xxx.zip", archive_content }
  #   let( :archive_content ){ {
  #         'hello.txt' => 'hello',
  #         'subdir/too.txt' => 'in a subdir'
  #   } }

  #   it 'handmade: plausibility and manual check' do
  #     zip_data.write_to(zip_file)
  #     %x{unzip -oqq #{zip_file} -d #{tmp_output}}
  #     archive_content.each do | rel_path, content |
  #       expect(File.read(File.join(tmp_output, rel_path))).to eq(content)
  #     end
  #   end
  # end

  # context 'archive from dir tree' do
  #   let( :dir ){ fixtures_path 'meta_zip' }
  #   let( :zip_data ){ make_zip_from_tree dir }

  #   let( :archive_content ){ {
  #     'one/alpha'        => "alpha\n",
  #     'two/beta'         => "beta\n",
  #     'two/subdir/gamma' => "gamma\n"
  #   } }

  #   it 'directory: plausibility and manual check' do
  #     zip_data.write_to(zip_file)
  #     %x{unzip -oqq #{zip_file} -d #{tmp_output}}
  #     archive_content.each do | rel_path, content |
  #       expect(File.read(File.join(tmp_output, rel_path))).to eq(content)
  #     end
  #   end

  # end
  
end
