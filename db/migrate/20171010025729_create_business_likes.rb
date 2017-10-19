class CreateBusinessLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :business_likes do |t|
      t.references :business, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end

    add_index :business_likes, [:user_id, :business_id], unique: true
  end
end
