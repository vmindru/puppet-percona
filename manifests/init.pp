# == Class: percona
#
# Module for Percona XtraDB management.
#
# === Parameters
#
# [*percona version*]
#   The Percona mysql version to be used. Currently 5.5
#
# [*root_password*]
#   The root password of the database
#
# [*old_passwords*]
#   Set this to true to support the old mysql 3.x hashes for the passwords
#
# [*datadir*]
#   The mysql data directory, defaults to /var/lib/mysql
#
# [*ist_recv_addr*]
#   The IST receiver address for WSREP
#
# [*mysql_cluster_servers*]
#   The string have to contains the ip or the fqan of the servers in the cluster parted by comma, like <ip1>,<ip2>,...
#
# [*wsrep_cluster_address*]
#   The WSREP cluster address list. It takes the value from the mysql_cluster_servers
#
# [*wsrep_provider*]
#   The WSREP provider
#
# [*wsrep_sst_receive_address*]
#   The SST receiver address
#
# [*wsrep_sst_user*]
#   The WSREP SST user, used to auth
#
# [*wsrep_sst_password*]
#   The WSREP SST password, used to auth
#
# [*wsrep_sst_method*]
#   The WSREP SST method, like rsync or xtrabackup
#
# [*wsrep_cluster_name*]
#   The WSREP cluster name
#
# [*wsrep_sst_donor*]
#   The WSREP donor host should be the chosen master host
#
# [*binlog_format*]
#   The binlog format
#
# [*default_storage_engine*]
#   The default storage engine
#
# [*innodb_autoinc_lock_mode*]
#   The innodb lock mode
#
# [*innodb_locks_unsafe_for_binlog*]
#   Set this to true if you want to use unsafe locks for the binlogs
#
# [*innodb_buffer_pool_size*]
#   The innodb buffer pool size
#
# [*innodb_log_file_size*]
#   The innodb log file size
#
# [*innodb_file_per_table*]
#   Set this to true to allow using sepafate files for the innodb tablespace
#
# [*master*]
#   Set this to true to the first host in the cluster you are installing.
#

class percona(
  $percona_version = '5.5',
  $root_password = undef,
  $old_passwords = false,
  $datadir = '/var/lib/mysql',
  $ist_recv_addr = $ipaddress,
  $mysql_cluster_servers = 'ipadresses',
  $wsrep_cluster_address = "gcomm://${mysql_cluster_servers}",
  $wsrep_provider = $percona::params::percona_provider,
  $wsrep_sst_receive_address = "${ipaddress}:4020",
  $wsrep_sst_user = 'sstuser',
  $wsrep_sst_password = 'sStus3r4020',
  $wsrep_sst_method = 'xtrabackup',
  $wsrep_cluster_name = 'custerPercona',
  $wsrep_sst_donor = undef,
  $binlog_format = 'ROW',
  $default_storage_engine = 'InnoDB',
  $innodb_autoinc_lock_mode = '2',
  $innodb_locks_unsafe_for_binlog = '1',
  $innodb_buffer_pool_size = '128M',
  $innodb_log_file_size = '256M',
  $innodb_file_per_table = '1',
  $client            = true,
  $config_content    = undef,
  $config_dir_mode   = '0750',
  $config_file_mode  = '0640',
  $config_user       = 'root',
  $config_group      = 'root',
  $config_template   = undef,
  $config_skip       = false,
  $config_replace    = true,
  $config_include_dir = undef,
  $config_file       = undef,
  $server            = true,
  $master            = false,
  $service_enable    = true,
  $service_ensure    = 'running',
  $service_name      = 'mysql',
  $service_restart   = true,
  $daemon_group      = 'mysql',
  $daemon_user       = 'mysql',
  $tmpdir            = undef,
  $logdir            = '/var/log/percona',
  $logdir_group      = 'root',
  $socket            = '/var/lib/mysql/mysql.sock',
  $datadir           = '/var/lib/mysql',
  $targetdir         = '/data/backups/mysql/',
  $errorlog          = '/var/log/mysqld.log',
  $pidfile           = '/var/run/mysqld/mysqld.pid',
  $manage_repo       = true,

  $pkg_client        = undef,
  $pkg_server        = undef,
  $pkg_common        = undef,
  $pkg_compat        = undef,
  $pkg_version       = undef,

  $mgmt_cnf          = undef,

  $default_configuration  = {
    '5.5'    => {},
    '5.1'    => {},
    'global' => {},
  }
) inherits percona::params {

  
  if $master {
    include percona::preinstall
    include percona::install
    include percona::configure
    include percona::master

    Class['percona::preinstall'] ->
    Class['percona::install'] ->
    Class['percona::configure'] ->
    Class['percona::master']
  } else {
    include percona::preinstall
    include percona::install
    include percona::configure

    Class['percona::preinstall'] ->
    Class['percona::install'] ->
    Class['percona::configure']
  }
}
