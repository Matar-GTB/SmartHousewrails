class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :username, :string       
    add_column :users, :age, :integer
    add_column :users, :gender, :string
    add_column :users, :birthdate, :date
    add_column :users, :member_type, :string     #  rôle dans la maison
    add_column :users, :first_name, :string      # Nom (privé)
    add_column :users, :last_name, :string       # Prénom (privé)
  end
  end
end
