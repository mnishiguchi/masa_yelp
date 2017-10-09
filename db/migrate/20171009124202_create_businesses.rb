class CreateBusinesses < ActiveRecord::Migration[5.1]
  def change
    create_table :businesses do |t|
      t.string :yelp_identifier

      t.timestamps
    end

    add_index :businesses, :yelp_identifier, unique: true
  end
end
