# frozen_string_literal: true

json.array! @mosquitto_accounts, partial: 'mosquitto_accounts/mosquitto_account', as: :mosquitto_account
