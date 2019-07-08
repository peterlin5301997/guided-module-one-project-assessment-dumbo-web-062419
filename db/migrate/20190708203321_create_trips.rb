class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.integer :user_id
      t.integer :city_from_id
      t.integer :city_to_id
      #t.date :depart_date
      #t.time :depart_time
    end
  end
end
