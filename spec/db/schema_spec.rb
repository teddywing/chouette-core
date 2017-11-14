RSpec.describe ActiveRecord::Schema do
  it "uses type `bigint` for primary and foreign keys" do
    non_bigint_primary_keys = []
    non_bigint_foreign_keys = []

    File.open('db/schema.rb', 'r') do |f|
      non_bigint_primary_keys = f
        .grep(/create_table /)
        .grep_v(/id: :bigserial/)

      f.rewind

      non_bigint_foreign_keys = f
        .grep(/t\.integer +"\w+_id"/)
        .grep_v(/limit: 8/)
    end

    expect(non_bigint_primary_keys).to be_empty
    expect(non_bigint_foreign_keys).to be_empty
  end
end
