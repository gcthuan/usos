class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.string :name
      t.string :phone_number
      t.integer :content_id
      t.timestamps
    end
  end
end
