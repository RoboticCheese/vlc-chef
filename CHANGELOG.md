Vlc Cookbook CHANGELOG
======================

v1.1.0 (2016-03-04)
-------------------
- Bump apt dependency from 2.x to 3.x

v1.0.0 (2015-12-09)
-------------------
- Update to Chef custom resources (breaking compatibility with Chef < 12.5)
- Add RHEL support
- Change the `node['vlc']['version']` attribute to the better-namespaced
  `node['vlc']['app']['version']`

v0.3.0 (2015-06-23)
-------------------
- Give the `vlc_app` resource an optional `version` attribute
- Fix bug with OS X package's mount volume name

v0.2.0 (2015-06-21)
-------------------
- Remove hardcoded version strings in OS X and Windows providers; get latest
  version from the VLC site during the Chef run

v0.1.0 (2015-06-20)
-------------------
- Initial release for OS X, Windows, Ubuntu/Debian, and FreeBSD!

v0.0.1 (2015-06-14)
-------------------
- Development started
