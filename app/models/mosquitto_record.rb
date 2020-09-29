class MosquittoRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { reading: :mqtt0, writing: :mqtt0 }
end
