require 'securerandom'
require 'base64'

class MosquittoAccount < MosquittoRecord
  belongs_to :provision_request

  def generate_password!
    unencoded_password = SecureRandom.base64(36)
    salt = SecureRandom.base64(16)
    iterations = 100000

    encoded = Base64.encode64(OpenSSL::PKCS5::pbkdf2_hmac(unencoded_password, salt, iterations, 24, OpenSSL::Digest::SHA512.new)).chomp

    hashed_password = "PBKDF2$sha512$#{iterations}$#{salt}$#{encoded}"

    puts "unencoded password for device is #{unencoded_password}"
    puts "encoded password for device is #{hashed_password}"
    self.password = hashed_password
    self.save

    return unencoded_password
  end
end
