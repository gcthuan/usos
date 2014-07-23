class AddDeviceIdToContent < ActiveRecord::Migration
  def change
  	add_column :contents, :device_id, :integer
  end
end
