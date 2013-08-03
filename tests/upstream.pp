#
# Testing installation from upstream
#
class { 'kibana':
  install => 'upstream',
  version => '0.90.1',
}
