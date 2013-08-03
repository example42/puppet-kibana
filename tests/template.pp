#
# Testing configuration file provisioning via template
# Auditing enabled
#
class { 'kibana':
  template => 'kibana/tests/test.conf',
  audit    => 'all',
}
