class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :small_image_url
      t.string :medium_image_url
      t.string :normal_image_url
      t.integer :message_id
      t.timestamps
    end
  end
end
