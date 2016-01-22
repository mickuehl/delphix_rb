
class Delphix::BaseArray < Array

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
  
end