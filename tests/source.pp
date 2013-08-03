#
# Testing configuration file provisioning via source
# Auditing enabled
#
class { 'kibana':
  source => 'puppet:///modules/kibana/tests/test.conf',
  audit  => 'all',
}
