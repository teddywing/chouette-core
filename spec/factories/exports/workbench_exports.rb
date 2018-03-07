FactoryGirl.define do
  factory :workbench_export, class: Export::Workbench, parent: :export do
    file { File.open(Rails.root.join('spec', 'fixtures', 'OFFRE_TRANSDEV_2017030112251.zip')) }
  end
end
