include stdlib

# == Class: percona::configure
#
# Configure percona and mysql cnf file
#
class percona::configure inherits percona {

    $wsrep_provider_options = "gmcast.listen_addr=tcp://0.0.0.0:4010; ist.recv_addr=${percona::ist_recv_addr}; evs.keepalive_period = PT3S; evs.inactive_check_period = PT10S; evs.suspect_timeout = PT30S; evs.inactive_timeout = PT1M; evs.install_timeout = PT1M;"

    file {$::percona::percona_conf:
        content => template('percona/my.cnf.erb'),
        #notify  => Service[$percona::percona_service]
    }

    file {$::percona::datadir:
        ensure => directory,
        owner  => mysql,
        group  => mysql,
        #notify => Service[$percona::percona_service]
    }

    if (!$percona::master) {
      service { $percona::percona_service:
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require    => [File[$percona::percona_conf],File[$percona::datadir]],
      }
    }

    file {'/etc/services': ensure => present, }
    
    file_line { 'mysqlchk':
      path => '/etc/services',
      line => 'mysqlchk 9200/tcp',
    }
    
    file {'/etc/xinetd.d/mysqlchk': ensure => present, }
    
    exec { 'sed mysqlchk':
      command => "sed -i '/server          =/a \       \ server_args     = clusterchckuser CLUSTERCHECK_PWD' /etc/xinetd.d/mysqlchk",
      path    => [ '/bin', '/usr/bin' ],
      onlyif  => "grep -q CLUSTERCHECK_PWD /etc/xinetd.d/mysqlchk; if [ $? -ne 0 ]; then (exit 0); else (exit 1); fi"
    }

}
