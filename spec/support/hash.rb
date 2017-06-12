class << Hash
  def without(hash, *keys)
    nk = hash.keys - keys
    Hash[*nk.zip(hash.values_at(*nk)).flatten]
  end
end
