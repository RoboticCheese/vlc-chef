# Encoding: UTF-8
#
# Cookbook Name:: vlc
# Library:: resource_vlc_app_freebsd
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
    # A FreeBSD implementation of the vlc_app resource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VlcAppFreebsd < VlcApp
      provides :vlc_app, platform: 'freebsd'

      #
      # Ensure Ports is up to date and install the VLC package.
      #
      action :install do
        include_recipe 'freebsd::portsnap'
        package 'vlc' do
          version new_resource.version
          action :install
        end
      end

      #
      # Remove the VLC package.
      #
      action :remove do
        package 'vlc' do
          action :remove
        end
      end
    end
  end
end
