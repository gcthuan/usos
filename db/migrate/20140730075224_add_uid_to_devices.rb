class AddUidToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :uid, :string
  end
end
