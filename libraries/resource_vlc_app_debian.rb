# Encoding: UTF-8
#
# Cookbook Name:: vlc
# Library:: resource_vlc_app_debian
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

require_relative 'resource_vlc_app'

class Chef
  class Resource
    # A Debian/Ubuntu implementation of the vlc_app resource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VlcAppDebian < VlcApp
      provides :vlc_app, platform_family: 'debian'

      #
      # Use a regular package resource to install VLC, since it's available
      # in APT.
      #
      action :install do
        include_recipe 'apt'
        package 'vlc' do
          version new_resource.version
          action :install
        end
      end

      #
      # Use a regular package resource to uninstall VLC.
      #
      action :remove do
        package 'vlc' do
          action :remove
        end
      end
    end
  end
end
