# class percona master
# this class is set just for the first host.

class percona::master inherits percona {

  service {"mysql@bootstrap.service":
	ensure => "running",
  }
  exec { 'init user sstuser':
    command => "mysql -u root -e \"CREATE USER \'${percona::wsrep_sst_user}\'@\'localhost\' IDENTIFIED BY \'${percona::wsrep_sst_password}\';\"",
    path    => [ '/bin', '/usr/bin' ],
    unless  => "test -f ${percona::datadir}/DO_NOT_REMOVE_RESETPASSWORD",
    require => Service["mysql@bootstrap.service"]
  } ->
  exec { 'grant privileges':
    command => "mysql -u root -e \"GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO \'${percona::wsrep_sst_user}\'@\'localhost\';\"",
    path    => [ '/bin', '/usr/bin' ],
    unless  => "test -f ${percona::datadir}/DO_NOT_REMOVE_RESETPASSWORD",
    require => Service["mysql@bootstrap.service"],
  } ~>
  exec { 'grant process':
    command => "mysql -u root -e \"GRANT PROCESS ON *.* TO 'clustercheckuser'@'localhost' IDENTIFIED BY 'CLUSTERCHECK_PWD'; FLUSH PRIVILEGES;\"",
    path    => [ '/bin', '/usr/bin' ],
    unless  => "test -f ${percona::datadir}/DO_NOT_REMOVE_RESETPASSWORD",
    require => Service["mysql@bootstrap.service"],
  } ~> 
  exec {'set-percona-root-password':
    command => "mysqladmin -u root password \"${percona::root_password}\"",
    path    => ['/usr/bin'],
    unless  => "test -f ${percona::datadir}/DO_NOT_REMOVE_RESETPASSWORD",
    require => Service["mysql@bootstrap.service"],
  }
  file {"${percona::datadir}/DO_NOT_REOVE_RESETPASSWORD":
	path => "${percona::datadir}/DO_NOT_REMOVE_RESETPASSWORD",
        ensure => "present" ,
        content => "DO NOT REMOVE THIS FILE, THIS FILE IS USED BY PUPPET TO IDENTIFY IF THIS HOST NEEDS MYSQL SYSTEM USERS PASSWORD RESETS DURING SETUP" ,
  } 
}
