require 'blockwalker/readers'

module BlockWalker
  
  # See https://en.bitcoin.it/wiki/Script for actual defs
  class Script
    attr_reader :ops
    
    OPS = {
      0x00 => :OP_0,

      0x4f => :OP_1NEGATE,
      
      0x51 => :OP_1,
      0x52 => :OP_2,
      0x53 => :OP_3,
      0x54 => :OP_4,
      0x55 => :OP_5,
      0x56 => :OP_6,
      0x57 => :OP_7,
      0x58 => :OP_8,
      0x59 => :OP_9,
      0x5a => :OP_10,
      0x5b => :OP_11,
      0x5c => :OP_12,
      0x5d => :OP_13,
      0x5e => :OP_14,
      0x5f => :OP_15,
      0x60 => :OP_16,
      
      0x61 => :OP_NOP,
      0x63 => :OP_IF,
      0x64 => :OP_NOTIF,
      0x67 => :OP_ELSE,
      0x68 => :OP_ENDIF,
      0x69 => :OP_VERIFY,
      0x6a => :OP_RETURN,
      
      0x6b => :OP_TOTALTSTACK,
      0x6c => :OP_FROMALTSTACK,
      0x73 => :OP_IFDUP,
      0x74 => :OP_DEPTH,
      0x75 => :OP_DROP,
      0x76 => :OP_DUP,
      0x77 => :OP_NIP,
      0x78 => :OP_OVER,
      0x79 => :OP_PICK,
      0x7a => :OP_ROLL,
      0x7b => :OP_ROT,
      0x7c => :OP_SWAP,
      0x6d => :OP_2DROP,
      0x6e => :OP_2DUP,
      0x6f => :OP_3DUP,
      0x70 => :OP_2OVER,
      0x71 => :OP_2ROT,
      0x72 => :OP_2SWAP,

      0x7e => :OP_CAT,
      0x7f => :OP_SUBSTR,
      0x80 => :OP_LEFT,
      0x81 => :OP_RIGHT,
      0x82 => :OP_SIZE,
      
      0x88 => :OP_EQUALVERIFY,

      0xac => :OP_CHECKSIG,
      0xa9 => :OP_HASH160
    }

    def initialize(script_data)
      @ops = []
      process_script(script_data)
    end

    def push opcode, rest
      size = opcode
      push_data = rest[0..size-1].unpack("H#{size}")
      rest = rest[size..-1]
      @ops << [:PUSH, push_data]
      rest
    end

    def next_opcode script_data
      opcode = script_data[0].unpack("C")[0]
      rest = script_data[1..-1]

      if opcode >= 0x01 and opcode <= 0x4b
        rest = push(opcode, rest)
      elsif OPS.has_key? opcode
        @ops << [OPS[opcode]]
      else
        raise "UNKNOWN OPCODE 0x#{opcode.to_s(16)}"
      end
      rest
    end

    def process_script(script_data)
      while !script_data.empty?
        script_data = next_opcode(script_data)
      end
    end
    
  end
end
