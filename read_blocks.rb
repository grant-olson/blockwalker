MAGIC_NETWORK_ID = 0xD9B4BEF9

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

class Input
  include Readers

  attr_reader :input_hash, :input_tx_index, :response_script_length, :response_script, :sequence_number

  def initialize(blockfile)
    load_input(blockfile)
  end
  
  def load_input(blockfile)
    @input_hash = get_hash(blockfile)
    @input_tx_index = get_signed_int(blockfile)
    @response_script_length = get_variable_int(blockfile)
    @response_script = blockfile.read(@response_script_length).unpack("H#{response_script_length}")[0]
    @sequence_number = get_signed_int(blockfile)
  end
end

class Output
  include Readers

  def initialize(blockfile)
    load_output(blockfile)
  end
  
  attr_reader :output_value, :challenge_script_length, :challenge_script

  def load_output(blockfile)
    @output_value = get_unsigned_int_64(blockfile)
    @challenge_script_length = get_variable_int(blockfile)
    @challenge_script = blockfile.read(@challenge_script_length).unpack("H#{challenge_script_length}")[0]
  end
  
end

class Transaction
  include Readers

  def initialize(blockfile)
    load_tx(blockfile)
  end
  
  attr_reader :transaction_version, :input_count, :inputs, :output_count, :outputs, :lock_time

  def load_tx blockfile
    @transaction_version = get_unsigned_int(blockfile)
    raise "BAD TX VERSION" if @transaction_version != 1

    @input_count = get_variable_int(blockfile)
    @inputs = []

    1.upto(@input_count) do
      @inputs << Input.new(blockfile)
    end


    @output_count = get_variable_int(blockfile)
    @outputs = []

    1.upto(@output_count) do
      @outputs << Output.new(blockfile)
    end
    
    @lock_time = get_unsigned_int(blockfile)
    raise "Bad Lock Time #{@lock_time}" if @lock_time != 0
  end

end


class Block
  include Readers


  attr_reader :network_id, :block_length, :block_format, :last_hash,
    :merkle_root, :timestamp, :bits, :nonce, :transaction_count, :transactions

  def initialize(blockfile)
    load_block blockfile
  end

  def load_block blockfile
    @network_id = get_unsigned_int(blockfile)
    raise "BAD NETWORK ID #{network_id}" if @network_id != MAGIC_NETWORK_ID

    @block_length = get_unsigned_int(blockfile)
    @block_format = get_unsigned_int(blockfile)
    raise "BAD BLOCK FORMAT" if @block_format != 1

    @last_hash = get_hash(blockfile)
    @merkle_root = get_hash(blockfile)
    @timestamp = get_unsigned_int(blockfile)
    @bits = get_unsigned_int(blockfile)
    @nonce = get_unsigned_int(blockfile)

    @transaction_count = get_variable_int(blockfile)
    @transactions = []

    1.upto(@transaction_count) do
      @transactions << Transaction.new(blockfile)
    end
  end
end

blockfile = File.open("blocks/blk00000.dat")

while !blockfile.eof?
  b = Block.new(blockfile)
  puts "NETWORK ID #{b.network_id}"
  puts "LENGTH #{b.block_length}"
  puts "LAST HASH #{b.last_hash}"
  puts "MERKLE ROOT #{b.merkle_root}"
  puts "TIMESTAMP #{b.timestamp}"
  puts "TARGET #{b.bits}"
  puts "NONCE #{b.nonce}"
  puts "TX #{b.transaction_count}"

  b.transactions.each do |tx|
    puts "\tTX VERSION #{tx.transaction_version}"
    puts "\tINPUTS #{tx.input_count}"

    tx.inputs.each do |input|
      puts "\t\tINPUT HASH #{input.input_hash}"
      puts "\t\tINPUT TX INDEX #{input.input_tx_index}"
      puts "\tRESPONSE SCRIPT LENGTH #{input.response_script_length}"
      puts "\tRESPONSE SCRIPT #{input.response_script}"
      puts "\tSEQUENCE NUMBER #{input.sequence_number}"
   end
    
    puts "\tOUTPUTS #{tx.output_count}"
    tx.outputs.each do |output|
      puts "\t\tOUTPUT VALUE #{output.output_value}"
      puts "\tCHALLENGE SCRIPT LENGTH #{output.challenge_script_length}"
      puts "\tCHALLENGE SCRIPT #{output.challenge_script}"
    end

    puts "LOCK TIME #{tx.lock_time}"
  end
end
