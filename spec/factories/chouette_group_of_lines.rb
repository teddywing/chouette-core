FactoryGirl.define do

  factory  :group_of_line, :class => Chouette::GroupOfLine do
    sequence(:name) { |n| "Group Of Line #{n}" }
    sequence(:objectid) { |n| "test:GroupOfLine:#{n}:loc" }
    sequence(:registration_number) { |n| "#{n}" }

    association :line_referential
  end

end
