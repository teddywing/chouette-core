# require 'spec/support/file_fixtures'

FactoryGirl.define do
  # include FileFixtures

  factory :workbench_import, class: WorkbenchImport, parent: :import do
    # file { file_fixture('OFFRE_TRANSDEV_2017030112251.zip') }
  end
end
