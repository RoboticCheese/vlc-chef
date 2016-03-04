# Encoding: UTF-8
#
# Cookbook Name:: vlc
# Library:: resource_vlc_app_windows
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
    # A Windows implementation of the vlc_app resource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VlcAppWindows < VlcApp
      include Vlc::Helpers

      PATH ||= ::File.expand_path('/Program Files/VideoLAN/VLC')

      provides :vlc_app, platform_family: 'windows'

      #
      # Download and then install the VLC package.
      #
      action :install do
        windows_package 'VLC media player' do
          source remote_path
          installer_type :nsis
          action :install
        end
      end

      #
      # Use a windows_package resource to uninstall VLC.
      #
      action :remove do
        windows_package 'VLC media player' do
          action :remove
        end
      end

      #
      # Use the version helper methods to construct a remote download URL.
      #
      # @return [String] a download URL
      #
      def remote_path
        v = version || latest_version
        "https://get.videolan.org/vlc/#{v}/win64/vlc-#{v}-win64.exe"
      end
    end
  end
end
