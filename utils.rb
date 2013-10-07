module Utils
  class << self
    def hex2str(hex)
      hex.scan(/../).map { |h| h.to_i(16) }.pack("C*")
    end

    def str2hex(str)
      str.unpack("C*").map { |h| "%.2x" % h }.join
    end

    def str2arr(str)
      str.unpack("C*")
    end

    def arr2str(arr)
      arr.pack("C*")
    end

    def hex2arr(hex)
      str2arr(hex2str(hex))
    end

    def arr2hex(arr)
      str2hex(arr2str(arr))
    end
  end
end

class Array
  def ^(other)
    zip(other).map { |b1, b2| b1 ^ b2 }
  end
end

class String
  def ^(other)
    Utils.arr2str(Utils.str2arr(self) ^ Utils.str2arr(other))
  end

  def each_slice(slice_size, &block)
    Utils.str2arr(self).each_slice(slice_size) do |arr|
      yield Utils.arr2str(arr)
    end
  end
end
