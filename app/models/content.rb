class Content < ActiveRecord::Base
  has_many :photos, :dependent => :destroy, :autosave => :true
  has_one :user_info, :dependent => :destroy, :autosabe => :true
  accepts_nested_attributes_for :photos
  accepts_nested_attributes_for :user_info
end
