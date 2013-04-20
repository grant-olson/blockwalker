require 'blockwalker/readers'

module BlockWalker
  class Input
    include BlockWalker::Readers

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
end
