#
# = Class: kibana::config
#
# This class manages kibana configurations
#
class kibana::config {

  if $kibana::file {
    file { 'kibana.conf':
      ensure  => $kibana::ensure,
      path    => $kibana::managed_file,
      mode    => $kibana::file_mode,
      owner   => $kibana::file_owner,
      group   => $kibana::file_group,
      source  => $kibana::file_source,
      content => $kibana::managed_file_content,
    }
  }

}
