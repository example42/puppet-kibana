# Class: kibana::dependency
#
# This class installs kibana dependency
#
# == Usage
#
# This class may contain resources available on the
# Example42 modules set.
#
class kibana::dependency {

  include java

  if $kibana::install != 'package' {
    git::reposync { 'kibana-servicewrapper':
      source_url      => 'https://github.com/kibana/kibana-servicewrapper.git',
      destination_dir => "${kibana::install_destination}/kibana-servicewrapper",
      post_command    => "cp -a ${kibana::install_destination}/kibana-servicewrapper/service/ ${kibana::home_dir}/bin ; chown -R ${kibana::user}:${kibana::user} ${kibana::home_dir}/bin/service",
      creates         => "${kibana::home_dir}/bin/service",
      before          => [ Class['kibana::service'] , Class['kibana::config'] ],
    }
    exec { 'kibana-servicewrapper-copy':
      command => "cp -a ${kibana::install_destination}/kibana-servicewrapper/service/ ${kibana::home_dir}/bin ; chown -R ${kibana::user}:${kibana::user} ${kibana::home_dir}/bin/service",
      path    => '/bin:/sbin:/usr/sbin:/usr/bin',
      creates => "${kibana::home_dir}/bin/service",
      require => Git::Reposync['kibana-servicewrapper'],
    }
    file { "${kibana::home_dir}/bin/service/kibana":
      ensure  => present,
      mode    => 0755,
      owner   => $kibana::user,
      group   => $kibana::user,
      content => template($kibana::init_script_file_template),
      before  => Class['kibana::service'],
      require => Git::Reposync['kibana-servicewrapper'],
    }
    file { "/etc/init.d/kibana":
      ensure  => "${kibana::home_dir}/bin/service/kibana",
    }
    file { "${kibana::home_dir}/bin/service/kibana.conf":
      ensure  => present,
      mode    => 0644,
      owner   => $kibana::user,
      group   => $kibana::user,
      content => template($kibana::init_options_file_template),
      before  => Class['kibana::service'],
      require => Git::Reposync['kibana-servicewrapper'],
    }
    file { "${kibana::home_dir}/logs":
      ensure  => directory,
      mode    => 0755,
      owner   => $kibana::user,
      group   => $kibana::user,
      before  => Class['kibana::service'],
      require => Git::Reposync['kibana-servicewrapper'],
    }
  }

}
