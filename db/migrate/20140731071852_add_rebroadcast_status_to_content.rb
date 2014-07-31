class AddRebroadcastStatusToContent < ActiveRecord::Migration
  def change
  	add_column :contents, :rebroadcast_status, :boolean, default: false
  end
end
