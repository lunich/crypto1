require './utils'

string1 = "attack at dawn"
cypher1 = "6c73d5240a948c86981bc294814d"
string2 = "attack at dusk"

key = string1 ^ Utils.hex2str(cypher1)
puts Utils.str2hex(key)
cypher2 = string2 ^ key
puts Utils.str2hex(cypher2)

################################################################################################

letters = (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + [' ', ',', ':', '.', "'", '!', '?'])
letter_bytes = letters.join.unpack("C*").map { |b| b ^ 0x20 }
mask_char = '*'
mask_byte = mask_char.unpack('C')[0]
space_char = ' '
space_byte = space_char.unpack('C')[0]

cipher_hexes = [
  "315c4eeaa8b5f8aaf9174145bf43e1784b8fa00dc71d885a804e5ee9fa40b16349c146fb778cdf2d3aff021dfff5b403b510d0d0455468aeb98622b137dae857553ccd8883a7bc37520e06e515d22c954eba50",
  "234c02ecbbfbafa3ed18510abd11fa724fcda2018a1a8342cf064bbde548b12b07df44ba7191d9606ef4081ffde5ad46a5069d9f7f543bedb9c861bf29c7e205132eda9382b0bc2c5c4b45f919cf3a9f1cb741",
  "32510ba9a7b2bba9b8005d43a304b5714cc0bb0c8a34884dd91304b8ad40b62b07df44ba6e9d8a2368e51d04e0e7b207b70b9b8261112bacb6c866a232dfe257527dc29398f5f3251a0d47e503c66e935de812",
  "32510ba9aab2a8a4fd06414fb517b5605cc0aa0dc91a8908c2064ba8ad5ea06a029056f47a8ad3306ef5021eafe1ac01a81197847a5c68a1b78769a37bc8f4575432c198ccb4ef63590256e305cd3a9544ee41",
  "3f561ba9adb4b6ebec54424ba317b564418fac0dd35f8c08d31a1fe9e24fe56808c213f17c81d9607cee021dafe1e001b21ade877a5e68bea88d61b93ac5ee0d562e8e9582f5ef375f0a4ae20ed86e935de812",
  "32510bfbacfbb9befd54415da243e1695ecabd58c519cd4bd2061bbde24eb76a19d84aba34d8de287be84d07e7e9a30ee714979c7e1123a8bd9822a33ecaf512472e8e8f8db3f9635c1949e640c621854eba0d",
  "32510bfbacfbb9befd54415da243e1695ecabd58c519cd4bd90f1fa6ea5ba47b01c909ba7696cf606ef40c04afe1ac0aa8148dd066592ded9f8774b529c7ea125d298e8883f5e9305f4b44f915cb2bd05af513",
  "315c4eeaa8b5f8bffd11155ea506b56041c6a00c8a08854dd21a4bbde54ce56801d943ba708b8a3574f40c00fff9e00fa1439fd0654327a3bfc860b92f89ee04132ecb9298f5fd2d5e4b45e40ecc3b9d59e941",
  "271946f9bbb2aeadec111841a81abc300ecaa01bd8069d5cc91005e9fe4aad6e04d513e96d99de2569bc5e50eeeca709b50a8a987f4264edb6896fb537d0a716132ddc938fb0f836480e06ed0fcd6e9759f404",
  "466d06ece998b7a2fb1d464fed2ced7641ddaa3cc31c9941cf110abbf409ed39598005b3399ccfafb61d0315fca0a314be138a9f32503bedac8067f03adbf3575c3b8edc9ba7f537530541ab0f9f3cd04ff50d",
  "32510ba9babebbbefd001547a810e67149caee11d945cd7fc81a05e9f85aac650e9052ba6a8cd8257bf14d13e6f0a803b54fde9e77472dbff89d71b57bddef121336cb85ccb8f3315f4b52e301d16e9f52f904"
]

cipher_bytes = cipher_hexes.map { |h| Utils.hex2arr(h) }

# initially - spaces
messages = cipher_bytes.map { |b| space_char * b.size }

# need to fill it manually step by step
messages = [
  "We can **c*or *he number *5 with quantu***omputers. We can also factor the number*1",
  "Euler w**l* probably enjoy tha* now**is***eorem becomes a corner ston* of crypt* * ",
  "Th* nic**t*ing about Keey*oq i* now**e cryptographers can drive a lot*of fancy *ars",
  "Th* cip**r*ext*produced b* a w*ak e**ry***on algorithm looks as good *s ciphert*x* ",
  "Yo* don't want to buy a s*t of*car **ys***om a guy who specializes in*stealing *a*s",
  "Th*re a** *wo *ypes of cr*ptog*aphy** t*** which will keep secrets sa*e from yo*r*l",
  "Th*re a** *wo *ypes of cy*togr*phy:**ne***at allows the Government to*use brute*f*r",
  "We*can **e*the*point wher* the*chip**s ***appy if a wrong bit is sent*and consu*e* ",
  "A *priv**e*key*  encrypti*n sc*eme **at***3 algorithms, namely a proc*dure for *e*e",
  " T*e Co**i*e O*fordDictio*ary *2006**de***nes crypto as the art of  w*iting o r*s*l",
  "Th* sec**t*mes*age is: Wh*n us*ng a**tr*** cipher, never use the key *ore than *n*e",
]
message_bytes = messages.map { |m| m.unpack("C*") }

puts "Step 0"
puts message_bytes.map { |a| a.pack("C*").inspect }

0.upto(cipher_hexes.size-1) do |n|
  0.upto(cipher_hexes.size-1) do |i|
    unless n == i
      cn_xor_ci = cipher_bytes[n] ^ cipher_bytes[i]
      message_bytes[n].zip(cn_xor_ci).each_with_index do |pair, index|
        message_byte, cn_xor_ci_byte = pair
        if message_byte == space_byte && !letter_bytes.include?(cn_xor_ci_byte)
          message_bytes[n][index] = mask_byte
        end
      end
    end
  end
end

puts "Step 1"
puts message_bytes.map { |a| a.pack("C*").inspect }

0.upto(cipher_hexes.size-1) do |n|
  0.upto(cipher_hexes.size-1) do |i|
    unless i == n
      message_bytes[n].each_with_index do |byte, pos|
        if mask_byte != byte
          message_bytes[i][pos] = cipher_bytes[n][pos] ^ cipher_bytes[i][pos] ^ byte
        end
      end
    end
  end
end

puts "Step 2"
puts message_bytes.map { |a| a.pack("C*").inspect }
