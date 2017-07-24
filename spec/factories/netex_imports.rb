FactoryGirl.define do
  factory :netex_import, class: NetexImport, parent: :import do
    file { File.open(Rails.root.join('spec', 'fixtures', 'terminated_job.json')) }
  end
end
