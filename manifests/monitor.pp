#
# = Class: kibana::monitor
#
# This class monitors kibana
#
class kibana::monitor (
  $enable   = $kibana::monitor,
  $tool     = $kibana::monitor_tool,
  $host     = $kibana::monitor_host,
  $protocol = $kibana::monitor_protocol,
  $port     = $kibana::monitor_port,
  $service  = $kibana::service,
  ) inherits kibana {

  if $port and $protocol == 'tcp' {
    monitor::port { "kibana_${kibana::protocol}_${kibana::port}":
      ip       => $host,
      protocol => $protocol,
      port     => $port,
      tool     => $tool,
      enable   => $enable,
    }
  }
  if $service {
    monitor::service { 'kibana_service':
      service  => $service,
      tool     => $tool,
      enable   => $enable,
    }
  }
}
