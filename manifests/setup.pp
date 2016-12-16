# Class: mesos::setup
#
# This class manages Mesos slave and master setups.
# Use this instead of mesos::master and mesos::slave
# methods separately.
#
# Parameters:
# [*slave*] - 'present' for installing any version of Mesos
#   'latest' or e.g. '0.15' for specific version
#
# [*master*] - 'present' for installing any version of Mesos
#   'latest' or e.g. '0.15' for specific version
#
# Sample Usage: is not meant for standalone usage, class is
# required by 'mesos::master' and 'mesos::slave'
#
class mesos::setup(
  $slave                 = undef,
  $slave_force_provider  = $mesos::slave::force_provider,
  $slave_manage_service  = $mesos::slave::manage_service,
  $slave_conf_file       = $mesos::slave::conf_file,
  $master                = undef,
  $master_force_provider = $mesos::master::force_provider,
  $master_manage_service = $mesos::master::manage_service,
  $master_conf_dir       = $mesos::master::conf_dir,
  $master_conf_file      = $mesos::master::conf_file,
) {

  # Run the config setups first
  contain mesos::master
  contain mesos::slave

  # Install mesos-slave service
  mesos::service { 'slave':
    enable         => $slave,
    force_provider => $slave_force_provider,
    manage         => $slave_manage_service,
    subscribe      => File[$slave_conf_file],
  }

  # Install mesos-master service
  mesos::service { 'master':
    enable         => $master,
    force_provider => $master_force_provider,
    manage         => $master_manage_service,
    subscribe      => [File[$master_conf_file], File[$master_conf_dir] ],
  }


}
