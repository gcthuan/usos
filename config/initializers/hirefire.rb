HireFire.configure do |config|
  if Rails.env.production?
    config.environment = :heroku
   else
    config.environment = :local
  end
  # add any other configuration you want here
end