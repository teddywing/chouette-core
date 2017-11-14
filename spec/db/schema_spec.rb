RSpec.describe ActiveRecord::Schema do
  it "uses type `bigint` for primary and foreign keys" do
    expect('db/schema.rb').to use_bigint_keys
  end
end


RSpec::Matchers.define :use_bigint_keys do
  match do |filename|
    @non_bigint_primary_keys = []
    @non_bigint_foreign_keys = []

    File.open(filename, 'r') do |f|
      @non_bigint_primary_keys = f
        .grep(/create_table /)
        .grep_v(/id: :bigserial/)

      f.rewind

      @non_bigint_foreign_keys = f
        .grep(/t\.integer +"\w+_id"/)
        .grep_v(/limit: 8/)
    end

    @non_bigint_primary_keys.empty? && @non_bigint_foreign_keys.empty?
  end

  failure_message do |filename|
    <<~EOS
      expected #{filename.inspect} to use bigint keys
      Diff: #{diff}
    EOS
  end

  def diff
    RSpec::Support::Differ.new(
      color: RSpec::Matchers.configuration.color?
    ).diff(@non_bigint_primary_keys + @non_bigint_foreign_keys, [])
  end
end
