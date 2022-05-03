require 'rails_helper'
RSpec.describe WalletService do
  let(:user) { User.create }
  let(:wallet) { user.create_wallet(balance: 10) }
  
  context '#deposit' do
    subject { described_class.new(wallet) }
    it 'raises InvalidAmountError if amount is not positive' do
      expect { subject.deposit(-10) }.to raise_error(WalletService::InvalidAmountError)
    end

    it 'updates wallet balance and create transaction' do
      expect { subject.deposit(30) }
        .to change { wallet.balance }.from(10).to(40)
        .and change { Transaction.count }.by(1)
    end
  end

  context '#withdraw' do
    subject { described_class.new(wallet) }

    it 'raises InvalidAmountError if amount is not positive ' do
      expect { subject.withdraw(-10) }.to raise_error(WalletService::InvalidAmountError)
    end

    it 'raises NoSufficientBalanceError if amount exceeds balance' do
      expect { subject.withdraw(30) }.to raise_error(WalletService::NoSufficientBalanceError)
    end

    it 'updates wallet balance and create transaction' do
      expect { subject.withdraw(10) }
      .to change { wallet.balance }.from(10).to(0)
      .and change { Transaction.count }.by(1)
    end
  end

  context '#transfer' do
    subject { described_class.new(wallet) }
    let(:receiver) { User.create }
    let(:receiver_wallet) { receiver.create_wallet(balance: 10) }

    it 'raises InvalidAmountError if amount is not positive ' do
      expect { subject.transfer(-10, receiver_wallet) }.to raise_error(WalletService::InvalidAmountError)
    end

    it 'raises NoSufficientBalanceError if amount exceeds balance' do
      expect { subject.transfer(30, receiver_wallet) }.to raise_error(WalletService::NoSufficientBalanceError)
    end

    it 'updates both wallet balance and create transactions' do
      expect { subject.transfer(10, receiver_wallet) }
      .to change { wallet.balance }.from(10).to(0)
      .and change { receiver_wallet.balance }.from(10).to(20)
      .and change { Transaction.count }.by(2)
    end
  end
end