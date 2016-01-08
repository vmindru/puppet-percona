# == Class percona::params
#
# === Parameters:
#
# $config_include_dir::     Folder to include using '!includedir' in the mysql
#                           configuration folder. Defaults to /etc/mysql/conf.d
#                           for debian. If overridden, we will attempt to
#                           create it but the parent directory should exist.
#
# $mgmt_cnf::               Path to the my.cnf file to use for authentication.
#
# $manage_repo::            This module can optionally install apt/yum repos.
#                           Disabled by default.
#
# $service_restart::        Should we restart the server after changing the
#                           configs? On some systems, this may be a bad thing.
#                           Ex: Wait for a maintenance weekend.
#
# $default_configuration::  A hash table containing specific options to set for
#                           a percona version. It should be a hashtable with
#                           for each percona version a sub-entry.
#
#
# === Provided parameters:
#
# $template::               Either the configured ($config_)template. Or our
#                           default template which is OS specific.
#
# $config_dir::             Location of the folder which holds the mysql my.cnf
#                           file for your operatingsystem.
#
# $config_file::            Location of the default mysql my.cnf config file
#                           for your operatingsystem.
#
# === Examples:
#
# ==== Setting global and default configuration options.
#
# === Todo:
#
# TODO: Document parameters
#
class percona::params {

  case $::operatingsystem {
  
    /(?i:debian|ubuntu)/: {
      $config_dir  = '/etc/mysql'
      $default_config_file = '/etc/mysql/my.cnf'
      $template = $percona::config_template ? {
        undef   => 'percona/my.cnf.Debian.erb',
        default => $percona::config_template,
      }
      $config_include_dir_default = "${config_dir}/conf.d"
      $percona_conf = '/etc/mysql/my.cnf'
      $percona_provider = '/usr/lib/libgalera_smm.so'
      $percona_host_table = 'mysql/user.frm'
      $percona_service = 'mysql'
      $percona_keyprefix = '1C4CBDCD'
      $percona_keynum = 'CD2EFD2A'
    }
    
    /(?i:redhat|centos|scientific)/: {
      $default_config_file = '/etc/my.cnf'
      $template    = $percona::config_template ? {
        undef   => 'percona/my.cnf.erb',
        default => $percona::config_template,
      }
      $config_include_dir_default = undef
      $percona_conf = '/etc/my.cnf'
      $percona_provider = '/usr/lib64/libgalera_smm.so'
      $percona_host_table = 'mysql/user.frm'
      $percona_service = 'mysql'
    }
    
    default: {
      fail('Operating system not supported yet.')
    }
  }
  
  $_config_file = $percona::config_file ? {
    undef   => $default_config_file,
    default => $percona::config_file,
  }

}
