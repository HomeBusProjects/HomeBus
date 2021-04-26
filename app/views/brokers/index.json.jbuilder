# frozen_string_literal: true

json.array! @brokers, partial: 'brokers/broker', as: :broker
