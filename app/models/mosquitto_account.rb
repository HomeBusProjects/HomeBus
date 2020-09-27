require 'securerandom'
require 'base64'

class MosquittoAccount < ApplicationRecord
  belongs_to :provision_request

  def generate_password!
    unencoded_password = SecureRandom.base64(36)
    salt = SecureRandom.base64(12)
    iterations = 10000

    encoded = Base64.encode64(OpenSSL::PKCS5::pbkdf2_hmac(unencoded_password, salt, iterations, 24, OpenSSL::Digest::SHA512.new)).chomp

    password = "PBKDF2$sha512$#{iteractions}$#{salt}$#{encoded}"


    unencoded_password = _get_random_string(32)

    hashed_password = ''

    if Rails.env.development?
      hashed_password = 'this is really not gonna work'
    else
      hashed_password = `np -i 1000 -p #{unencoded_password}`
      hashed_password.chomp!
    end

    puts "unencoded password for device is #{unencoded_password}"
    puts "encoded password for device is #{hashed_password}"
    self.password = hashed_password
    self.save

    return unencoded_password
  end

  private
  def _get_random_string(length)
    [ *'a'..'z', *'A'..'Z', *'0'..'9' ].to_a.shuffle[0, length].join
  end
end
