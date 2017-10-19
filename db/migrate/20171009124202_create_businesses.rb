class CreateBusinesses < ActiveRecord::Migration[5.1]
  def change
    create_table :businesses do |t|
      t.string :yelp_uid, null: false, index: true, unique: true
      t.string :name
      t.string :image_url
      t.string :url
      t.string :categories
      t.decimal :rating
      t.integer :price
      t.decimal :latitude
      t.decimal :longitude
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.string :display_address, array: true, default: []
      t.string :phone
      t.string :display_phone

      t.timestamps
    end
  end
end
