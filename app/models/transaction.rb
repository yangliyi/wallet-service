class Transaction < ApplicationRecord
  TYPES = {
    deposit: 'deposit',
    withdraw: 'withdraw',
    transfer: 'transfer'
  }.freeze

  validates :transaction_type, inclusion: { in: TYPES.values,
    message: "%{value} is not a valid type" }

  belongs_to :user
  belongs_to :wallet
end
