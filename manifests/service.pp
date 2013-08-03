#
# = Class: kibana::service
#
# This class manages kibana service
#
class kibana::service {

  if $kibana::service {
    service { $kibana::service:
      ensure     => $kibana::managed_service_ensure,
      enable     => $kibana::managed_service_enable,
      subscribe  => $kibana::service_subscribe,
      provider   => $kibana::managed_service_provider,
    }
  }

}
