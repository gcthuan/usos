class AddDeviceTokenToContent < ActiveRecord::Migration
  def change
    add_column :contents, :device_token, :string
  end
end
