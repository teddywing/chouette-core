FactoryGirl.define do
  factory :import_task do |f|
    user_name "dummy"
    user_id 123
    no_save false
    format "Neptune"
    resources { Rack::Test::UploadedFile.new 'spec/fixtures/neptune.zip', 'application/zip', false }
    referential { Referential.find_by_slug("first") }
  end
end
