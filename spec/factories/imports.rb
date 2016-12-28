FactoryGirl.define do
  factory :import do
    name "MyString"
    current_step_id "MyString"
    current_step_progress 1.5
    association :workbench
    association :referential
    file {File.open(File.join(Rails.root, 'spec', 'fixtures', 'terminated_job.json'))}
    status "MyString"
  end
end
