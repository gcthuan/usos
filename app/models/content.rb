class Content < ActiveRecord::Base
  has_many :photos, :dependent => :destroy, :autosave => :true
  has_one :user_info, :dependent => :destroy, :autosave => :true
  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :user_info

  def find_nearby_devices latitude, longitude, radius
  	device_list = Device.near([latitude, longitude], radius, units: :km, order: :distance)

  	puts "#{device_list.count} devices found"
  	
  	puts "---------------------------------------------------"

    #APNS.send_notification(device_list, alert: 'Hello iPhone!', badge: 1, sound: 'default', :other => {:sent => 'with apns gem', :custom_param => "value"})
  end

  def broadcast
  	delay(run_at: 0.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 1
  	delay(run_at: 1.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 2
  	delay(run_at: 2.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 3
  	delay(run_at: 3.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 5
  	delay(run_at: 4.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 8
  	delay(run_at: 5.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 13
    self.delay(run_at: 6.minute.from_now.utc).destroy
  end

end
