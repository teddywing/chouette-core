FactoryGirl.define do
  factory :netex_export, class: Export::Netex, parent: :export do
    file { File.open(Rails.root.join('spec', 'fixtures', 'OFFRE_TRANSDEV_2017030112251.zip')) }
    association :parent, factory: :workbench_export

  end
end
