class WalletService
  attr_reader :user, :wallet

  def initialize(wallet)
    @user = wallet.user
    @wallet = wallet
  end

  def deposit(amount)
    validate_amount!(amount)
    execute_transaction do
      wallet.update!(balance: wallet.balance + amount)
      Transaction.create!(
        user_id: user.id,
        wallet_id: wallet.id,
        amount: amount,
        transaction_type: Transaction::TYPES[:deposit]
      )
    end
  end

  def withdraw(amount)
    validate_amount!(amount)
    validate_balance!(amount)
    execute_transaction do
      wallet.update!(balance: wallet.balance - amount)
      Transaction.create!(
        user_id: user.id,
        wallet_id: wallet.id,
        amount: - amount,
        transaction_type: Transaction::TYPES[:withdraw]
      )
    end
  # rescue ActiveRecord::StaleObjectError => e
  end

  def transfer(amount, receiver_wallet)
    validate_amount!(amount)
    validate_balance!(amount)

    execute_transaction do
      wallet.update!(balance: wallet.balance - amount)
      receiver_wallet.update!(balance: receiver_wallet.balance + amount)

      Transaction.create!(
        user_id: user.id,
        wallet_id: wallet.id,
        amount: - amount,
        transaction_type: Transaction::TYPES[:transfer]
      )
      Transaction.create!(
        user_id: receiver_wallet.user.id,
        wallet_id: receiver_wallet.id,
        amount: amount,
        transaction_type: Transaction::TYPES[:transfer]
      )
    end
  # rescue ActiveRecord::StaleObjectError => e
  end

  class NoSufficientBalanceError < StandardError; end
  class InvalidAmountError < StandardError; end

  private

  def validate_amount!(amount)
    raise InvalidAmountError unless amount.positive?
  end

  def validate_balance!(amount)
    raise NoSufficientBalanceError unless wallet.sufficient_balance?(amount)
  end

  def execute_transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end
end