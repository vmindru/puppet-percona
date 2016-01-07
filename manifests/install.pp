# Class: percona::install
# vmindru: i have modified this file cause it contains reduntant logic inside , package dependecy must be managed by YUM! and not by this manifest
#
class percona::install {
  $server           = $::percona::server
  $client           = $::percona::client
  $percona_version  = $::percona::percona_version

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      $pkg_version = $percona_version
      $pkg_client_default = "percona-server-client-${pkg_version}"
      $pkg_server_default = "percona-server-server-${pkg_version}"

      case $percona_version {
        '5.1': {
          $pkg_common_default = [
            'percona-toolkit',
            'percona-server-common',
          ]
        }

        default: {
          $pkg_common_default = [
            'percona-toolkit',
            "percona-server-common-${pkg_version}",
          ]
        }
      }
    }

    /(?i:redhat|centos|scientific)/: {
      $pkg_version = regsubst($percona_version, '\.', '', 'G')
      $pkg = "Percona-XtraDB-Cluster-${pkg_version}"
    }
    default: {
      fail('Operating system not supported yet.')
    }
  }


#do the insatll   
  package {"$pkg":
	ensure => "installed" ,
        require => [
      Class['percona::preinstall']
    ],
  }

}

