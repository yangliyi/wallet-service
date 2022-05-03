class CreateWallets < ActiveRecord::Migration[6.1]
  def change
    create_table :wallets do |t|
      t.string :user_id,  null: false
      t.integer :balance,  null: false, default: 0
      t.timestamps
    end

    add_index :wallets, :user_id
    add_column :wallets, :lock_version, :integer, default: 0, null: false 
  end
end
