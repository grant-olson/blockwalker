require 'blockwalker/readers'
require 'blockwalker/transaction'

module BlockWalker
  class Block
    include Readers

    MAGIC_NETWORK_ID = 0xD9B4BEF9

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
end
