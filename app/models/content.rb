class Content < ActiveRecord::Base
  reverse_geocoded_by :latitude, :longitude
  has_many :photos, :dependent => :destroy, :autosave => :true
  has_one :user_info, :dependent => :destroy, :autosave => :true
  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :user_info
  serialize :ignored_list, Array

  def find_nearby_devices latitude, longitude, radius, device_token, username, ignored_list
    puts ignored_list
  	device_list = Device.near([latitude, longitude], radius, units: :km)
    token_list = Array.new
    device_list.each do |device|
      token_list << device.device_token
    end
  	puts "#{token_list.count} devices found"
  	puts "#{token_list}"
  	puts "---------------------------------------------------"

    #if ignore_list.nil?
    #  token_list = token_list - [device_token]
    #else
      token_list = token_list - ignored_list - [device_token]
    #end
    token_list.each do |token|
      puts token
      #APNS.send_notification(token.to_s, alert: "#{username} needs your help!", badge: 1, sound: 'default', :other => {:sent => 'with apns gem', :custom_param => "value"})
    end
    ignored_list = token_list
  end

  def broadcast
    delay(run_at: 0.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 1, self.device_token, self.user_info.name, self.ignored_list
  	delay(run_at: 1.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 2, self.device_token, self.user_info.name, self.ignored_list
  	delay(run_at: 2.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 3, self.device_token, self.user_info.name, self.ignored_list
  	delay(run_at: 3.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 5, self.device_token, self.user_info.name, self.ignored_list
  	delay(run_at: 4.minute.from_now.utc).find_nearby_devices self.latitude, self.longitude, 8, self.device_token, self.user_info.name, self.ignored_list
    if self.status == 'available'
      self.delay(run_at: 60.minutes.from_now.utc).update_attribute :status, "expired"
    end
  end

end
