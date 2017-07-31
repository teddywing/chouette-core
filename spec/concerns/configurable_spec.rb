RSpec.describe Configurable do

  subject do
    Class.new do
      include Configurable
    end
  end

  let( :something ){ double('something') }

  it 'can be configured' do
    expect{ subject.config.anything }.to raise_error(NoMethodError)

    subject.config.something = something

    expect( subject.config.something ).to eq(something)
    # Instances delegate to the class
    expect( subject.new.send(:config).something ).to eq(something)
    # **All** instances delegate to the class
    expect( subject.new.send(:config).something ).to eq(something)
  end

  it 'can be configured with a block' do

    subject.config do | c |
      c.something = something 
    end

    expect( subject.config.something ).to eq(something)
    # Instances delegate to the class
    expect( subject.new.send(:config).something ).to eq(something)
    # **All** instances delegate to the class
    expect( subject.new.send(:config).something ).to eq(something)
  end
end
