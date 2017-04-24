module CoreHelper
  module ::Enumerable
    def zip_map
      map { |ele| [ele, yield(ele)] }
    end
  end
end
