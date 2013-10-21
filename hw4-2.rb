# d20bdba6ff29eed7b046d1df9fb70000
# 58b1ffb4210a580f748b4ac714c001bd
# 4a61044426fb515dad3f21f18aa577c0
# bdf302936266926ff37dbf7035d5eeb4

require 'net/http'
require 'uri'
require './utils'

blocks = [
  'f20bdba6ff29eed7b046d1df9fb70000',
  '58b1ffb4210a580f748b4ac714c001bd',
  '4a61044426fb515dad3f21f18aa577c0',
  'bdf302936266926ff37dbf7035d5eeb4'
]

def get_http_code(blocks)
  uri = URI("http://crypto-class.appspot.com/po")
  params = { er: blocks.map { |b| Utils.arr2hex(b) }.join }
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri).code
  puts params[:er] if '404' == res
  raise "200!" if '200' == res
  res
end

blocks_arrays = blocks.map { |b| Utils.hex2arr(b) }

array = []
test_block = blocks_arrays[2].dup

0x01.upto(0x10) do |block_index|
  0x09.upto(0x80) do |byte|
    (0x01...block_index).each do |i|
      test_block[-i] = (blocks_arrays[2][-i] ^ array[-i] ^ block_index)
    end
    test_block[-block_index] = (blocks_arrays[2][-block_index] ^ byte ^ block_index)

    if '404' == get_http_code([test_block, blocks_arrays[3]])
      array.insert(0, byte)
      break
    end
  end
end

puts array.inspect
puts array.pack("C*").inspect
