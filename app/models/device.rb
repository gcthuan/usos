class Device < ActiveRecord::Base
  reverse_geocoded_by :latitude, :longitude
  has_many :contents, :dependent => :destroy, :autosave => :true
end
