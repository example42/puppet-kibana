#
# = Class: kibana::config
#
# This class manages kibana configurations
#
class kibana::config {

  if $kibana::file {
    file { 'kibana.conf':
      ensure  => $kibana::file_ensure,
      path    => $kibana::managed_file,
      mode    => $kibana::file_mode,
      owner   => $kibana::file_owner,
      group   => $kibana::file_group,
      source  => $kibana::file_source,
      content => $kibana::managed_file_content,
    }
  }

  # Configuration Directory, if dir defined
  if $kibana::dir_source {
    file { 'kibana.dir':
      ensure  => $kibana::dir_ensure,
      path    => $kibana::managed_dir,
      source  => $kibana::dir_source,
      recurse => $kibana::dir_recurse,
      purge   => $kibana::dir_purge,
      force   => $kibana::dir_purge,
    }
  }

}
