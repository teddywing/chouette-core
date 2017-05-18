module Support
  module Subject
    def expect_it
      expect(subject)
    end
  end
end

RSpec.configure do |conf|
  conf.include Support::Subject
end
