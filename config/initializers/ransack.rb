Ransack.configure do |config|
  config.add_predicate 'between',
                       arel_predicate: 'between',
                       formatter: proc { |v| v.split(' to ') },
                       type: :string
end
module Arel
  module Predications
    def between other
      gteq(other[0]).and(lt(other[1]))
    end
  end
end
