MAGIC_NETWORK_ID = 0xD9B4BEF9

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
  f.read(32).unpack("H32")
end

def get_variable_int f
  int = f.read(1).unpack("C")[0]
  raise "VARIABLE INT TOO BIG" if (int >= 0xfd)
  int
end

def get_tx blockfile
  tx_version = get_unsigned_int(blockfile)
  raise "BAD TX VERSION" if tx_version != 1

  input_counts = get_variable_int(blockfile)
  puts "\tINPUT_COUNTS #{input_counts}"

  1.upto(input_counts) do
    input_hash = get_hash(blockfile)
    puts "\t\tINPUT HASH #{input_hash}"

    input_tx_index = get_signed_int(blockfile)
    puts "\t\tINPUT TX INDEX #{input_tx_index}"

    response_script_length = get_variable_int(blockfile)
    puts "\tRESPONSE SCRIPT LENGTH #{response_script_length}"

    response_script = blockfile.read(response_script_length).unpack("H#{response_script_length}")
    puts "\tRESPONSE SCRIPT #{response_script}"

    sequence_number = get_signed_int(blockfile)
    puts "\tSEQUENCE NUMBER #{sequence_number}"
  end


  output_count = get_variable_int(blockfile)
  puts "\tOUTPUT COUNT #{output_count}"

  1.upto(output_count) do
    output_value = get_unsigned_int_64(blockfile)
    puts "\t\tOUTPUT VALUE #{output_value}"

    challenge_script_length = get_variable_int(blockfile)
    puts "\tCHALLENGE SCRIPT LENGTH #{challenge_script_length}"

    challenge_script = blockfile.read(challenge_script_length).unpack("H#{challenge_script_length}")
    puts "\tCHALLENGE SCRIPT #{challenge_script}"
  end
  
  lock_time = get_unsigned_int(blockfile)
  raise "Bad Lock Time #{lock_time}" if lock_time != 0
  puts "\tLOCK TIME #{lock_time}"
end

def get_block blockfile
  network_id = get_unsigned_int(blockfile)
  raise "BAD NETWORK ID #{network_id}" if network_id != MAGIC_NETWORK_ID
  puts "NETWORK ID #{network_id}"

  block_length = get_unsigned_int(blockfile)
  puts "LENGTH #{block_length}"

  block_format = get_unsigned_int(blockfile)
  raise "BAD BLOCK FORMAT" if block_format != 1

  last_hash = get_hash(blockfile)
  puts "LAST HASH #{last_hash}"

  merkle_root = get_hash(blockfile)
  puts "MERKLE ROOT #{merkle_root}"

  timestamp = get_unsigned_int(blockfile)
  puts "TIMESTAMP #{timestamp}"

  bits = get_unsigned_int(blockfile)
  puts "TARGET #{bits}"

  nonce = get_unsigned_int(blockfile)
  puts "NONCE #{nonce}"

  tx_count = get_variable_int(blockfile)
  puts "TX #{tx_count}"

  1.upto(tx_count) do
    puts "\tTX NUMBER #{tx_count}"
    get_tx(blockfile)
  end
  
end

blockfile = File.open("blocks/blk00000.dat")

while !blockfile.eof?
  get_block(blockfile)
end
