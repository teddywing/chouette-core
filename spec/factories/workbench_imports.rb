FactoryGirl.define do
  factory :workbench_import, class: WorkbenchImport, parent: :import do
    file { File.open(Rails.root.join('spec', 'fixtures', 'OFFRE_TRANSDEV_2017030112251.zip')) }
  end
end
