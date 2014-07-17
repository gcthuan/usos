class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :audio_url
      t.time :audio_length
      t.float :longtitude
      t.float :latitude
      t.integer :user_id
      t.text :message
      t.timestamps
    end
  end
end
