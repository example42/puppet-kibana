# Puppet module: kibana

This is a Puppet module for kibana.
It manages its installation, configuration and service.

The module is based on stdmod naming standars.
Refer to http://github.com/stdmod/

Released under the terms of Apache 2 License.

NOTE: This module is to be considered a POC, that uses the stdmod naming conventions.
For development time reasons the module currently uses some Example42 modules and prerequisites.

## USAGE - Basic management

* Install kibana with default package, settings and dependencies

        class { 'kibana': }

* Install kibana fetching the upstream tarball

        class { 'kibana':
          install => 'upstream',
          version => '0.90.2',
        }

* Remove kibana package and purge all the managed files

        class { 'kibana':
          ensure => absent,
        }

* Create an kibana user with defined settings

        class { 'kibana':
          install     => 'upstream',
          user_create => true, # Default
          user_uid    => '899',
        }

* Do not create an kibana user when installing via upstream
  (You must provide it in othr ways)

        class { 'kibana':
          install     => 'upstream',
          user_create => false,
        }

* Manage Java settings

        class { 'kibana':
          java_heap_size => '2048', # Default: 1024
        }

* Specify a custom template to use for the init script and its path

        class { 'kibana':
          init_script_file           = '/etc/init.d/kibana', # Default
          init_script_file_template  = 'site/kibana/init.erb',
        }

* Provide a custom configuration file for the init script (here you can better tune Java settings)

        class { 'kibana':
          init_options_file_template  = 'site/kibana/init_options.erb',
        }


* Do not automatically restart services when configuration files change (Default: Class['kibana::config']).

        class { 'kibana':
          service_subscribe => false,
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


* Use custom source directory for the whole configuration dir.

        class { 'kibana':
          dir_source  => 'puppet:///modules/example42/kibana/conf/',
        }

* Use custom source directory for the whole configuration dir purging all the local files that are not on the dir.
  Note: This option can be used to be sure that the content of a directory is exactly the same you expect, but it is desctructive and may remove files.

        class { 'kibana':
          dir_source => 'puppet:///modules/example42/kibana/conf/',
          dir_purge  => true, # Default: false.
        }

* Use custom source directory for the whole configuration dir and define recursing policy.

        class { 'kibana':
          dir_source    => 'puppet:///modules/example42/kibana/conf/',
          dir_recursion => false, # Default: true.
        }

* Use custom template for main config file. Note that template and source arguments are alternative.

        class { 'kibana':
          file_template => 'example42/kibana/kibana.conf.erb',
        }

* Use a custom template and provide an hash of custom configurations that you can use inside the template

        class { 'kibana':
          filetemplate       => 'example42/kibana/kibana.conf.erb',
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

* Specify an alternative class where kibana monitoring is managed

        class { 'kibana':
          monitor_class => 'site::monitor::kibana',
        }

* Enable and configure monitoring (with default kibana::monitor)

        class { 'kibana':
          monitor             = true,                  # Default: false
          monitor_host        = $::ipaddress_eth0,     # Default: $::ipaddress
          monitor_port        = 9200,                  # Default
          monitor_tool        = [ 'nagios' , 'monit' ] # Default: ''
        }

* Enable and configure firewalling (with default kibana::firewall)

        class { 'kibana':
          firewall             = true,                  # Default: false
          firewall_src         = '10.0.0.0/24,          # Default: 0/0
          firewall_dst         = $::ipaddress_eth0,     # Default: 0/0
          firewall_port        = 9200,                  # Default
        }


## TESTING
[![Build Status](https://travis-ci.org/stdmod/puppet-kibana.png?branch=master)](https://travis-ci.org/stdmod/puppet-kibana)
