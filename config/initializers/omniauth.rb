Rails.application.config.middleware.use OmniAuth::Builder do
  provider :flickr, 'a52641f4fc5064f017257f7b312f3445', 'eaf9c9a478fa37bd', scope: 'read'
end
