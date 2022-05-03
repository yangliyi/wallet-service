class Wallet < ApplicationRecord
  belongs_to :user
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def sufficient_balance?(amount)
    balance >= amount
  end
end