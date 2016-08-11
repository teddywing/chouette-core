FactoryGirl.define do

  factory  :group_of_line, :class => Chouette::GroupOfLine do
    sequence(:name) { |n| "Group Of Line #{n}" }
    sequence(:objectid) { |n| "chouette:test:GroupOfLine:#{n}" }
    sequence(:registration_number) { |n| "#{n}" }

    association :line_referential
  end

end
