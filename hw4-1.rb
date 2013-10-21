require "./utils"

# 01
iv = 0x20814804c1767293b99f1d9cab3bc3e7

original = "Pay Bob 100$"
changed  = "Pay Bob 500$"

puts (iv ^ Utils.str2hex(original).to_i(16) ^ Utils.str2hex(changed).to_i(16)).to_s(16)
# 0x20814804c1767293b99f1d9caf3bc3e7