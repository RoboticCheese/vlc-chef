# Encoding: UTF-8
#
# Cookbook Name:: vlc
# Library:: resource_vlc_app_rhel
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
    # A RHEL and RHEL-alike implementation of the vlc_app resource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VlcAppRhel < VlcApp
      provides :vlc_app, platform_family: 'rhel'

      #
      # Set up the EPEL and Nux Dextop YUM repos and install the VLC package.
      #
      action :install do
        include_recipe 'yum-epel'
        major = node['platform_version'].to_i
        yum_repository 'nux-dextop' do
          description 'Nux Dextop desktop and multimedia packages'
          baseurl "http://li.nux.ro/download/nux/dextop/el#{major}/$basearch/"
          gpgkey 'http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro'
        end
        package 'vlc' do
          version new_resource.version if new_resource.version
        end
      end

      #
      # Use a regular package resource to uninstall VLC. It's possible other
      # packages outside of this cookbook depend on EPEL and/or Nux Dextop,
      # so we have no choice but to leave the YUM repos in place.
      #
      action :remove do
        package 'vlc' do
          action :remove
        end
      end
    end
  end
end
