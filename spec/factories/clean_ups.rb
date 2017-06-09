FactoryGirl.define do
  factory :clean_up do
    begin_date { Date.today}
    end_date   { Date.today + 1.month }
  end
end
