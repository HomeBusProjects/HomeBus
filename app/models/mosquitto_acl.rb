class MosquittoAcl < ApplicationRecord
  include Bitfields

  belongs_to :provision_request

  bitfield :permissions, read: 1, write: 2, subscribe: 4
end
