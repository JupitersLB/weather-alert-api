class AddFirebaseUserIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :firebase_user_id, :string, default: nil, unique: true
  end
end
