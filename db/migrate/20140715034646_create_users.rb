class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fullname
      t.string :device_imei
      t.string :device_id
      t.string :phone
      t.float :longtitude
      t.float :latitude
      t.timestamps
    end
  end
end
