class CreateBusinessFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :business_favorites do |t|
      t.references :business, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end

    add_index :business_favorites, [:user_id, :business_id], unique: true
  end
end
