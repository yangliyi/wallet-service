class User < ApplicationRecord
  has_one :wallet
  has_many :transactions
end
