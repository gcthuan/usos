class AddIgnoredListToContent < ActiveRecord::Migration
  def change
    add_column :contents, :ignored_list, :text
  end
end
