name 'build_cookbook'
maintainer 'Martin Zimmermann'
maintainer_email 'more_spam@gmx.de'
license 'apachev2'
version '0.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

depends 'delivery-truck'
