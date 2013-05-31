class Hash
  def same_keys? other_hash
    return false unless keys.sort == other_hash.keys.sort
    true
  end
end
