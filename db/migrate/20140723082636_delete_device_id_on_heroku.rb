class DeleteDeviceIdOnHeroku < ActiveRecord::Migration
  def change
  	remove_column :contents, :device_id
  end
end
