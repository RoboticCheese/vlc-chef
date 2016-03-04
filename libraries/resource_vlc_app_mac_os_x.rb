# Encoding: UTF-8
#
# Cookbook Name:: vlc
# Library:: resource_vlc_app_mac_os_x
#
# Copyright 2015-2016, Jonathan Hartman
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

require_relative 'helpers'
require_relative 'resource_vlc_app'

class Chef
  class Resource
    # An OS X implementation of the vlc_app resource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VlcAppMacOsX < VlcApp
      include Vlc::Helpers

      PATH ||= '/Applications/VLC.app'.freeze

      provides :vlc_app, platform_family: 'mac_os_x'

      #
      # Use a dmg_package resource to download and install the package. The
      # dmg_resource creates an inline remote_file, so this is all that's
      # needed.
      #
      action :install do
        dmg_package 'VLC' do
          source remote_path
          volumes_dir "vlc-#{version || latest_version}"
          action :install
        end
      end

      #
      # For lack of a package manager, delete all of VLC's directories.
      #
      action :remove do
        [
          PATH,
          ::File.expand_path('~/Library/Application Support/VLC'),
          ::File.expand_path('~/Library/Application Support/org.videolan.vlc')
        ].each do |d|
          directory d do
            recursive true
            action :delete
          end
        end
      end

      #
      # Use the version helper methods to construct a remote download URL.
      #
      # @return [String] a download URL
      #
      def remote_path
        v = version || latest_version
        "https://get.videolan.org/vlc/#{v}/macosx/vlc-#{v}.dmg"
      end
    end
  end
end
