class Hash
  # Returns true if both hashes have the same (sorted) keys.
  def same_keys?(other_hash)
    return false unless keys.sort == other_hash.keys.sort
    true
  end
end
