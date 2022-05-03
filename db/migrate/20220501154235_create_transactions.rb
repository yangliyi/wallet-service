class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :user_id,  null: false
      t.string :wallet_id,  null: false

      t.integer :amount,  null: false
      t.string :transaction_type,  null: false

      t.timestamps
    end

    add_index :transactions, :user_id
    add_index :transactions, :wallet_id
  end
end
