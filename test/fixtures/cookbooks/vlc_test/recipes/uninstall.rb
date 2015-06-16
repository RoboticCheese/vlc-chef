# Encoding: UTF-8

include_recipe 'vlc'

vlc_app 'default' do
  action :remove
end
