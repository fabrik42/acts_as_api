module ActsAsApi
  #
  class ApiTemplate < Hash

    def add(val, options = {})
      self[(options[:as] || val).to_sym] = val
    end

    def remove(key)
      self.delete(key)
    end

  end
end
