
class Delphix::BaseArray < Array
  #
  # lookup_by_ref, lookup_by_name & lookup_by_type assume that there is only
  # one match in the array. In case there are multiple matches, the first one
  # is returned.
  #
  def lookup_by_ref(ref)
    return nil if self.size == 0
    self.each do |o|
      return o if o.reference == ref
    end
    return nil
  end

  def lookup_by_name(name)
    return nil if self.size == 0
    self.each do |o|
      return o if o.name == name
    end
    return nil
  end

  def lookup_by_type(type)
    return nil if self.size == 0
    self.each do |o|
      return o if o.type == type
    end
    return nil
  end

  #
  # Filters an array bases on a key and a value.
  # NOTE: The resulting array is a shallow copy of the original array!
  #
  def filter_by(key, value)
    return nil if self.size == 0
    a = Delphix::BaseArray.new
    self.each do |o|
      a << o if o.details[key] == value
    end
    return nil if a.size == 0
    a
  end

end
