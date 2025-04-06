class AddLockableToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :failed_attempts, :integer, default: 0, null: false  # nombre de tentatives ratées
    add_column :users, :unlock_token, :string   # jeton pour débloquer le compte
    add_column :users, :locked_at, :datetime    # date de blocage du compte

    add_index :users, :unlock_token, unique: true
  end
end
