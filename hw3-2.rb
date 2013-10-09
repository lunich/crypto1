require 'digest/sha2'
require './utils'

blocks = []
File.open("./6 - 1 - Introduction (11 min).mp4", "rb") do |file|
  while !file.eof?
    blocks << file.read(1024)
  end
end

hash_0 = ''
(blocks.size - 1).downto(0) do |k|
  hash_0 = Utils.hex2str(Digest::SHA256.hexdigest(blocks[k] + hash_0))
end

puts Utils.str2hex(hash_0)
