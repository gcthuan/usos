class Content < ActiveRecord::Base
  reverse_geocoded_by :latitude, :longitude
  has_many :photos, :dependent => :destroy, :autosave => :true, foreign_key: :photo_id
  has_one :user_info, :dependent => :destroy, :autosave => :true, foreign_key: :user_info_id
  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :user_info

  def find_nearby_devices latitude, longitude, radius, device_token
  	device_list = Device.near([latitude, longitude], radius, units: :km, order: :distance)

  	puts "#{device_list.count} devices found"
  	
  	puts "---------------------------------------------------"

    #APNS.send_notification(device_list.exclude(device_token), alert: 'Hello iPhone!', badge: 1, sound: 'default', :other => {:sent => 'with apns gem', :custom_param => "value"})
  end

  def broadcast
  	delay(run_at: 0.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 1, self.device_token
  	delay(run_at: 1.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 2, self.device_token
  	delay(run_at: 2.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 3, self.device_token
  	delay(run_at: 3.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 5, self.device_token
  	delay(run_at: 4.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 8, self.device_token
    self.delay(run_at: 10.minute.from_now.utc).destroy
  end

end
