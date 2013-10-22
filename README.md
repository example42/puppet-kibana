# Puppet module: kibana

This is a Puppet module for Kibana3: http://three.kibana.org/ .

It manages its installation and configuration.

The module is based on stdmod naming standars.
Refer to http://github.com/stdmod/

Released under the terms of Apache 2 License.

NOTE: This module is to be considered a POC, that uses the stdmod naming conventions.
For development time reasons the module currently uses some Example42 modules and prerequisites.


## USAGE - Common parameters

* Installation of kibana with common configuration parameters

        class { 'kibana':
          elasticsearch_url => "http://elastic.${::domain}:9200",
          webserver         => 'apache',
          virtualhost       => 'logs.example42.com', # Default: kibana.${::domain}
          file_template     => 'example42/kibana/config.js',
        }


## USAGE - Basic management

* Install kibana fetching the upstream master.zip.
  Note: By default kibana is installed but no webserver is configured to serve its files.

        class { 'kibana': }

* Install kibana and setup apache to serve it with a custom virtualhost

        class { 'kibana':
          webserver   => 'apache',
          virtualhost => 'logs.example42.com', # Default: kibana.${::domain}
        }

* Install kibana from a custom url to a custom destination

        class { 'kibana':
          install_url         => 'http://files.example42.com/kibana/3.1.zip',
          install_destination => '/var/www/html', # Default: /opt
        }

* Define the url of your elastisearch server

        class { 'kibana':
          elasticsearch_url => "http://elastic.${::domain}:9200",
        }

* Install kibana fetching a specific version

        class { 'kibana':
          install => 'upstream',
          version => '3.0.1',
        }

* Install kibana via OS package

        class { 'kibana':
          install => 'package',
        }

* Remove kibana package and purge all the managed files

        class { 'kibana':
          ensure => absent,
        }

* Enable auditing (on all the arguments)

        class { 'kibana':
          audit => 'all',
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'kibana':
          noop => true,
        }


## USAGE - Overrides and Customizations
* Use custom source for main configuration file

        class { 'kibana':
          file_source => [ "puppet:///modules/example42/kibana/kibana.conf-${hostname}" ,
                           "puppet:///modules/example42/kibana/kibana.conf" ],
        }


* Use custom template for main config file. Note that template and source arguments are alternative.

        class { 'kibana':
          file_template => 'example42/kibana/kibana.conf.erb',
        }

* Use a custom template and provide an hash of custom configurations that you can use inside the template

        class { 'kibana':
          file_template       => 'example42/kibana/kibana.conf.erb',
          file_options_hash  => {
            opt  => 'value',
            opt2 => 'value2',
          },
        }


* Specify the name of a custom class to include that provides the dependencies required by the module

        class { 'kibana':
          dependency_class => 'site::kibana_dependency',
        }


* Automatically include a custom class with extra resources related to kibana.
  Here is loaded $modulepath/example42/manifests/my_kibana.pp.
  Note: Use a subclass name different than kibana to avoid order loading issues.

        class { 'kibana':
          my_class => 'site::my_kibana',
        }


## TESTING
[![Build Status](https://api.travis-ci.org/example42/puppet-kibana.png?branch=master)](https://travis-ci.org/example42/puppet-kibana)
