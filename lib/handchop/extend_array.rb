module EArray
  refine Array do
    def traverse(&block)
      yield self
      self[1].each{|j| j.traverse(&block) } if self[1].is_a?(Array)
    end
  end
end
