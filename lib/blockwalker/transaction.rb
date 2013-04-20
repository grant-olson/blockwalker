require 'blockwalker/readers'
require 'blockwalker/input'
require 'blockwalker/output'

module BlockWalker
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
end
