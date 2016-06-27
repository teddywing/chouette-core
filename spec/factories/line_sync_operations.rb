FactoryGirl.define do
  factory :line_sync_operation do
    status ["OK","KO"].sample
    line_referential_sync nil
  end
end
