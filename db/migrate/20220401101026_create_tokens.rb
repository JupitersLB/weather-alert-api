class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens, id: :uuid do |t|
      t.string :value
      t.string :label
      t.string :scopes, array: true, default: []
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :tokens, :value
  end
end
