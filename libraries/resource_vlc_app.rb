# Encoding: UTF-8
#
# Cookbook Name:: vlc
# Library:: resource_vlc_app
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

require 'chef/resource'
require_relative 'helpers'

class Chef
  class Resource
    # A Chef resource for the VLC app.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class VlcApp < Resource
      property :version,
               [String, nil],
               default: nil,
               callbacks: {
                 'Invalid version' => ->(a) { Vlc::Helpers.valid_version?(a) }
               }

      default_action :install

      %i(install remove).each do |a|
        action a do
          raise(
            NotImplementedError,
            "Action `#{a}` must be implemented for `#{self.class}` resource"
          )
        end
      end
    end
  end
end
