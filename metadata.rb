maintainer       "John Dyer"
maintainer_email "jdyer@voxeo.com"
license          "All rights reserved"
description      "Installs/Configures Prism application server http://voxeo.com/prism"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "2.8.5"
name             "prism"
%w(jmxsh).each{|lib| depends lib}
