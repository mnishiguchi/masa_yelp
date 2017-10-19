class CreateBusinesses < ActiveRecord::Migration[5.1]
  def change
    create_table :businesses do |t|
      t.string :yelp_uid, null: false, index: true, unique: true
      t.string :name
      t.string :image_url
      t.string :url
      t.string :rating
      t.string :price
      t.string :phone
      t.string :display_phone
      t.jsonb :categories, array: true
      t.jsonb :coordinates
      t.jsonb :location

      t.timestamps
    end
  end
end
