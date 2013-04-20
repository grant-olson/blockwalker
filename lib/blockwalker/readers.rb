module BlockWalker
  module Readers
    def get_unsigned_int f
      f.read(4).unpack("L<")[0]
    end

    def get_unsigned_int_64 f
      f.read(8).unpack("Q<")[0]
    end

    def get_signed_int f
      f.read(4).unpack("l<")[0]
    end

    def get_hash f
      f.read(32).unpack("H32")[0]
    end

    def get_variable_int f
      int = f.read(1).unpack("C")[0]
      raise "VARIABLE INT TOO BIG #{int}" if (int >= 0xfd)
      int
    end
  end
end
