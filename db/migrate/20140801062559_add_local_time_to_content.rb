class AddLocalTimeToContent < ActiveRecord::Migration
  def change
    add_column :contents, :local_time, :datetime
  end
end
