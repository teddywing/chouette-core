# Convenience meta spec to debug potential bugs in zip support helpers
# uncomment run and check files in `zip_fixtures_path`
# RSpec.describe 'ZipData', type: [:zip, :meta] do

#   let( :zip_file ){ zip_fixtures_path('xxx.zip') }

#   before do
#     clear_all_zip_fixtures!
#   end

#   context 'a simple file' do
#     let( :zip_data ){ 
#       make_zip "xxx.zip",
#         'hello.txt' => 'hello',
#         'subdir/too.txt' => 'in a subdir'
#     }


#     it 'check' do
#       zip_data.write_to(zip_file)
#     end
#   end
  
# end
