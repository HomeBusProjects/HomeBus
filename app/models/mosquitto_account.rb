class MosquittoAccount < ApplicationRecord
  belongs_to :provision_request

  def generate_password!
    unencoded_password = _get_random_string(32)

    hashed_password = `np -p #{password}`
    hashed_password.chomp!

    puts "unencoded password for device is #{unencoded_password}"
    self.password = hashed_password
    self.save

    return unencoded_password
  end

  private
  def _get_random_string(length)
    [ *'a'..'z', *'A'..'Z', *'0'..'9' ].to_a.shuffle[0, length].join
  end
end
