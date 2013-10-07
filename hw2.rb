require "openssl"
require "./utils"

class AES
  def encrypt_cbc(str, key, iv)
    prepare_for_encryption(str, key, iv)
    Utils.str2hex(do_encrypt)
  end

  def decrypt_cbc(str, key)
    prepare_for_decryption(str, key, 16)
    do_decrypt_cbc
  end

  def decrypt_ctr(str, key)
    prepare_for_decryption(str, key, 16)
    do_decrypt_ctr
  end

private
  def prepare_for_decryption(str, key, iv_size)
    @key = Utils.hex2str(key)
    arr = Utils.hex2str(str)
    @iv = arr[0, iv_size]
    @data = arr[iv_size..-1]
    # decryptor
    @cipher = OpenSSL::Cipher.new('AES128')
    @cipher.padding = 0
    @cipher.decrypt
  end

  def prepare_for_encryption(str, key, iv)
    @key, @iv = Utils.hex2str(key), Utils.hex2str(iv)
    @data = str
    # encryptor
    @cipher = OpenSSL::Cipher.new('AES128')
    @cipher.padding = 0
    @cipher.encrypt
  end

  def do_decrypt_ctr
    @result = ''
    i = 0
    @data.each_slice(16) do |slice|
      h, l = @iv.unpack("Q*")
      l += i
      dec = decrypt_block([h, l].pack("Q*"))
      @result += slice ^ dec
    end
    @result
  end

  def do_decrypt_cbc
    @result = ''
    @data.each_slice(16) do |slice|
      dec = decrypt_block(slice)
      @result += dec ^ @iv
      @iv = slice
    end
    @result
  end

  def do_encrypt
    @result = @iv
    @data.each_slice(16) do |slice|
      slice = align_block(slice, 16)
      block_for_aes = @iv ^ slice
      @result += (@iv = encrypt_block(block_for_aes))
    end
    @result
  end

  def decrypt_block(block)
    @cipher.key = @key
    @cipher.update(block)
  end

  def encrypt_block(block)
    @cipher.key = @key
    @cipher.update(block)
  end

  def align_block(block, size)
    if (delta = size - block.size) > 0
      block += ([delta] * delta).pack("C*")
    end
    block
  end
end

crypter = AES.new

enc = "4ca00ff4c898d61e1edbf1800618fb2828a226d160dad07883d04e008a7897ee2e4b7465d5290d0c0e6c6822236e1daafb94ffe0c5da05d9476be028ad7c1d81"
key = "140b41b22a29beb4061bda66b6747e14"
puts res = crypter.decrypt_cbc(enc, key)
raise "INVALID" unless enc == crypter.encrypt_cbc(res, key, enc[0, 32])

enc = "5b68629feb8606f9a6667670b75b38a5b4832d0f26e1ab7da33249de7d4afc48e713ac646ace36e872ad5fb8a512428a6e21364b0c374df45503473c5242a253"
key = "140b41b22a29beb4061bda66b6747e14"
puts res = crypter.decrypt_cbc(enc, key)
raise "INVALID" unless crypter.encrypt_cbc(res, key, enc[0, 32])

enc = "69dda8455c7dd4254bf353b773304eec0ec7702330098ce7f7520d1cbbb20fc388d1b0adb5054dbd7370849dbf0b88d393f252e764f1f5f7ad97ef79d59ce29f5f51eeca32eabedd9afa9329"
key = "36f18357be4dbd77f050515c73fcf9f2"
puts res = crypter.decrypt_ctr(enc, key)

enc = "770b80259ec33beb2561358a9f2dc617e46218c0a53cbeca695ae45faa8952aa0e311bde9d4e01726d3184c34451"
key = "36f18357be4dbd77f050515c73fcf9f2"
puts res = crypter.decrypt_ctr(enc, key)
