RSpec.describe ObjectidSupport do

  subject do
    # Any class including the concern would do
    Chouette::Route
  end

  let!(:instance_1){ create(subject.table_name.singularize, objectid: "AAA:BBB:FOO-BAR1-1:CCC") }
  let!(:instance_2){ create(subject.table_name.singularize, objectid: "AAA:BBB:FOO-BAR1-2:CCC") }
  let!(:instance_10){ create(subject.table_name.singularize, objectid: "AAA:BBB:FOO-BAR1-10:CCC") }
  let(:instance_text){ create(subject.table_name.singularize, objectid: "AAA:BBB:FOO-BAR1-foobarbaz:CCC") }

  it 'should be searchable by short_id as integer' do
    referential = build_stubbed(:referential)
    expect(referential.objectid_formatter.class.short_id_type).to eq(:int)

    result = subject.search(short_id_lteq: 10, referential: referential).result
    expect(result).to include(instance_1)
    expect(result).to include(instance_2)
    expect(result).to include(instance_10)
  end

  it 'should be searchable by short_id as text' do
    instance_text

    result = subject.search(short_id_lteq: 10).result
    expect(result).to include(instance_1)
    expect(result).to include(instance_10)
    # 2 < 10 but '2' > '10'
    expect(result).to_not include(instance_2)

    result = subject.search(short_id_cont: 'bar').result
    expect(result).to_not include(instance_1)
    expect(result).to_not include(instance_2)
    expect(result).to_not include(instance_10)
    expect(result).to include(instance_text)
  end
end
