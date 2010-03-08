# small extensions to the NilClass

class NilClass
	def to_str
		''
  end

  def +(str)
    str
  end

end