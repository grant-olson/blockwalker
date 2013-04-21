require 'blockwalker/readers'
require 'blockwalker/script'

module BlockWalker
  class Output
    include Readers

    def initialize(blockfile)
      load_output(blockfile)
    end
    
    attr_reader :output_value, :challenge_script_length, :challenge_script

    def load_output(blockfile)
      @output_value = get_unsigned_int_64(blockfile)
      @challenge_script_length = get_variable_int(blockfile)
      @challenge_script = BlockWalker::Script.new(blockfile.read(@challenge_script_length))
    end
  end
end
