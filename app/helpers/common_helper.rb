
module CommonHelper
  def string_keys_to_symbols enumerable_pairs
    enumerable_pairs.inject({}){ | hashy, (k, v) |
      hashy.merge k.to_sym => v
    }
  end
end
