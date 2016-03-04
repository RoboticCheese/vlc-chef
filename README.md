Vlc Cookbook
============
[![Cookbook Version](https://img.shields.io/cookbook/v/vlc.svg)][cookbook]
[![Linux Build Status](https://img.shields.io/circleci/project/RoboticCheese/vlc-chef.svg)][circle]
[![OS X Build Status](https://img.shields.io/travis/RoboticCheese/vlc-chef.svg)][travis]
[![Windows Build Status](https://img.shields.io/appveyor/ci/RoboticCheese/vlc-chef.svg)][appveyor]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/vlc-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/vlc-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/vlc
[circle]: https://circleci.com/gh/RoboticCheese/vlc-chef
[appveyor]: https://ci.appveyor.com/project/RoboticCheese/vlc-chef
[travis]: https://travis-ci.org/RoboticCheese/vlc-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/vlc-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/vlc-chef

A Chef cookbook for VLC.

Requirements
============

As of v1.0.0, Chef 12.5 is generally required, though it may be possible to use
it in earlier versions of Chef 12 via the
[compat_resource](https://supermarket.chef.io/cookbooks/compat_resource)
cookbook.

This cookbook currently supports a number of platforms. It uses the dmg,
windows, apt, and freebsd community cookbooks for OS X, Windows, Ubuntu/Debian,
and FreeBSD support, respectively.

For RHEL support, it uses the [Nux Dextop](http://li.nux.ro/repos.html) YUM
repo (which also depends on EPEL), as EPEL has no VLC packages and RPMForge
doesn't have any for RHEL 7.

Usage
=====

Either add the default recipe to your run_list or implement the resource
directly in a recipe of your own.

Recipes
=======

***default***

Performs an attribute-driven install of VLC.

Attributes
==========

***default***

A specific version of VLC can be installed if you so desire:

    default['vlc']['app']['version'] = nil

Resources
=========

***vlc_app***

A platform-agnostic parent resource that defines the properties and actions for
all the platform-specific child resources.

Syntax:

    vlc_app 'default' do
        version '1.2.3'
        action :install
    end

Actions:

| Action     | Description       |
|------------|-------------------|
| `:install` | Install the app   |
| `:remove`  | Uninstall the app |

Attributes:

| Attribute  | Default    | Description                   |
|------------|------------|-------------------------------|
| version    | `nil`      | A specific version to install |
| action     | `:install` | Action(s) to perform          |

***vlc_app_mac_os_x***

OS X implementation of the `vlc_app` resource.

***vlc_app_windows***

Windows implementation of the `vlc_app` resource.

***vlc_app_debian***

Debian/Ubuntu implementation of the `vlc_app` resource.

***vlc_app_rhel***

RHEL (and RHEL-alike) implementation of the `vlc_app` resource.

***vlc_app_freebsd***

FreeBSD implementation of the `vlc_app` resource.

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2015-2016, Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
