# Encoding: UTF-8
#
# Cookbook Name:: vlc
# Library:: helpers
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

require 'net/http'

module Vlc
  # A set of helper methods for the vlc cookbook.
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  module Helpers
    #
    # Sort the list of available VLC versions and return the newest one.
    #
    # @return [String] the latest VLC version
    #
    def latest_version
      @latest_version ||= begin
        versions.map { |v| Gem::Version.new(v) }.sort.last.to_s
      end
    end

    #
    # Find all the valid version strings in the VLD download page's HTML.
    #
    # @return [Array] an array of version strings
    #
    def versions
      @versions ||= begin
        vlc_site_body.lines.map do |l|
          match = l.match(%r{^<a href="([0-9]+\.[0-9]+\.[0-9]+)/">})
          match && match[1]
        end.compact
      end
    end

    #
    # Get the VLC download directory page and save it for later processing.
    #
    # @return [String] the HTML site body
    #
    def vlc_site_body
      @vlc_site_body ||= begin
        # PSA: A 301 is returned if the ending / is missing from the URL
        u = URI.parse('https://get.videolan.org/vlc/')
        opts = { use_ssl: u.scheme == 'https',
                 ca_file: Chef::Config[:ssl_ca_file] }
        Net::HTTP.start(u.host, u.port, opts) { |h| h.get(u) }.body
      end
    end

    #
    # Determine whether a given string is a valid version.
    #
    # @param arg [String] a potential version string
    #
    # @return [TrueClass, FalseClass] whether the string is valid
    #
    def self.valid_version?(arg)
      arg.match(/^[0-9]+\.[0-9]+\.[0-9]+$/) ? true : false
    end
  end
end
