# frozen_string_literal: true

require 'jwt'
require 'dotenv/load'

class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      pp payload, exp, exp.to_i

      payload[:exp] = exp.to_i
      JWT.encode(payload, ENV['NETWORK_AUTH_KEY'], 'HS512')
    end

    def decode(token)
      body = JWT.decode(token, ENV['NETWORK_AUTH_KEY'], true, { algorithm: 'HS512' })[0]
    rescue StandardError => e
      pp 'rescue', e.backtrace, e
      nil
    end
  end
end
