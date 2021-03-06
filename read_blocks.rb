require 'blockwalker'

blockfile = File.open("blocks/blk00000.dat")

while !blockfile.eof? do
  b = BlockWalker::Block.new(blockfile)
  puts "NETWORK ID #{b.network_id}"
  puts "LENGTH #{b.block_length}"
  puts "LAST HASH #{b.last_hash}"
  #puts "MERKLE ROOT #{b.merkle_root}"
  #puts "TIMESTAMP #{b.timestamp}"
  #puts "TARGET #{b.bits}"
  #puts "NONCE #{b.nonce}"
  #puts "TX #{b.transaction_count}"

  b.transactions.each do |tx|
    #puts "\tTX VERSION #{tx.transaction_version}"
    #puts "\tIN#PUTS #{tx.input_count}"

    puts "INPUTS"
    tx.inputs.each do |input|
      puts "OPS"
      input.response_script.ops.each do |op|
        puts "\t#{op.join(' ')}"
      end
      
      #puts "\t\tINPUT HASH #{input.input_hash}"
      #puts "\t\tINPUT TX INDEX #{input.input_tx_index}"
      #puts "\tRESPONSE SCRIPT LENGTH #{input.response_script_length}"
      #puts "\tRESPONSE SCRIPT #{input.response_script}"
      #puts "\tSEQUENCE NUMBER #{input.sequence_number}"
   end
    
    puts "OUTPUTS"
    #puts "\tOUT#PUTS #{tx.output_count}"
    tx.outputs.each do |output|
      puts "OPS"
      
      output.challenge_script.ops.each do |op|
        puts "\t#{op.join(' ')}"
      end
        
      #puts "\t\tOUTPUT VALUE #{output.output_value}"
      #puts "\t\tCHALLENGE SCRIPT LENGTH #{output.challenge_script_length}"
      #puts "\t\tCHALLENGE SCRIPT #{output.challenge_script}"
    end

    #puts "\tLOCK TIME #{tx.lock_time}"
  end
end
