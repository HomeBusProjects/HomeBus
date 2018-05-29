class MosquittoAccount < ApplicationRecord
  belongs_to :provision_request

  def generate_password!
    unencoded_password = _get_random_string(32)

    hashed_password = `np -i 1000 -p #{unencoded_password}`
    hashed_password.chomp!

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
