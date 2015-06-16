# Encoding: UTF-8
#
# Cookbook Name:: vlc
# Library:: provider_vlc_app_mac_os_x
#
# Copyright 2015 Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/provider/lwrp_base'
require_relative 'provider_vlc_app'

class Chef
  class Provider
    class VlcApp < Provider::LWRPBase
      # An provider for VLC for Mac OS X.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class MacOsX < VlcApp
        URL ||= 'http://get.videolan.org/vlc/2.2.1/macosx/vlc-2.2.1.dmg'
        PATH ||= '/Applications/VLC.app'

        private

        #
        # Use a dmg_package resource to download and install the package. The
        # dmg_resource creates an inline remote_file, so this is all that's
        # needed.
        #
        # (see PlexHomeTheaterApp#install!)
        #
        def install!
          dmg_package 'VLC' do
            source URL
            volumes_dir 'vlc-2.2.1'
            action :install
          end
        end
      end
    end
  end
end
