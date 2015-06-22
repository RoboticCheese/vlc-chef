# Encoding: UTF-8
#
# rubocop:disable SingleSpaceBeforeFirstArg
name             'vlc'
maintainer       'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license          'apache2'
description      'Installs VLC'
long_description 'Installs VLC'
version          '0.2.0'

depends          'dmg', '~> 2.2'
depends          'windows', '~> 1.37'
depends          'apt', '~> 2.7'
depends          'freebsd', '~> 0.3'

supports         'mac_os_x'
supports         'windows'
supports         'ubuntu'
supports         'debian'
supports         'freebsd'
# rubocop:enable SingleSpaceBeforeFirstArg
