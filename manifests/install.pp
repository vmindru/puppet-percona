# Class: percona::install
# vmindru: i have modified this file cause it contains reduntant logic inside , package dependecy must be managed by YUM! and not by this manifest
#
class percona::install {
  $server           = $::percona::server
  $client           = $::percona::client
  $percona_version  = $::percona::percona_version

  case $::operatingsystem {
    /(?i:redhat|centos|scientific)/: {
      $pkg_version = regsubst($percona_version, '\.', '', 'G')
      $pkg = "Percona-XtraDB-Cluster-${pkg_version}"
    }
    default: {
      fail('Operating system not supported yet.')
    }
  }

#do the insatll   
  package {$pkg:
  ensure        => 'installed' ,
        require => [
      Class['percona::preinstall']
    ],
  }

}

