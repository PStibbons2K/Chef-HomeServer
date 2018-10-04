name 'homeserver'
maintainer 'Martin Zimmermann'
maintainer_email 'more_spam@gmx.de'
license 'Apache-2.0'
description 'Installs/Configures homeserver'
long_description 'Installs/Configures homeserver'
version '0.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/homeserver/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/homeserver'

depends 'openldap', '>= 4.0.0'