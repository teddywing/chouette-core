FactoryGirl.define do
  factory :workbench_import, class: WorkbenchImport, parent: :import do
    file { File.open(Rails.root.join('spec', 'fixtures', 'terminated_job.json')) }
  end
end
