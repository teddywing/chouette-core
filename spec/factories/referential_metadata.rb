FactoryGirl.define do
  factory :referential_metadata, :class => 'ReferentialMetadata' do
    referential
    periodes { [ generate(:period) ] }
    lines { create_list(:line, 3) }
  end

  sequence :period do |n|
    date = Date.today + 2*n
    date..(date+1)
  end
end
