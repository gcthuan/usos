class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :audio_url
      t.float :longitude
      t.float :latitude
      t.timestamps
    end
  end
end
