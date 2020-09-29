class MosquittoAcl < MosquittoRecord
  include Bitfields

  belongs_to :provision_request

  bitfield :permissions, 1 => :read, 2 => :write, 4 => :subscribe
end
