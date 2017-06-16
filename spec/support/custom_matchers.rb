require 'rspec/expectations'

RSpec::Matchers.define :include_all do |expected|
  match do |actual|
    ( expected - actual ).empty?
  end
end
