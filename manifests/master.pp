# class percona master
# this class is set just for the first host.

class percona::master inherits percona {

  service {"mysql@bootstrap.service":
        ensure => "running",
  } ->
  # THIS WILL RUN SUPOSINGLY ONLY ON FIRST RUN WHEN THERE WILL BE NO ROOT PASSWORD SET
  exec {'set-percona-root-password':
    command => "mysqladmin -u root --password= password \'${percona::root_password}\'",
    path    => ['/usr/bin'],
    require => Service["mysql@bootstrap.service"],
    unless  => "test -f ${percona::datadir}/DO_NOT_REMOVE_RESETPASSWORD",
  } ->
  # WHEN  ${percona::datadir}/DO_NOT_REMOVE_RESETPASSWORD DOES NOT EXIST SET THE PASSWORDS
  exec { 'init user sstuser':
    command => "mysql -u root --password=\'$::percona::root_password\' -e \"CREATE USER \'${percona::wsrep_sst_user}\'@\'localhost\' IDENTIFIED BY \'${percona::wsrep_sst_password}\';\"",
    path    => [ '/bin', '/usr/bin' ],
    require => Service["mysql@bootstrap.service"],
    unless  => "test -f ${percona::datadir}/DO_NOT_REMOVE_RESETPASSWORD",
  } ->
  exec { 'grant privileges':
    command => "mysql -u root --password=\'$::percona::root_password\' -e \"GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO \'${percona::wsrep_sst_user}\'@\'localhost\';\"",
    path    => [ '/bin', '/usr/bin' ],
    require => Service["mysql@bootstrap.service"],
    unless  => "test -f ${percona::datadir}/DO_NOT_REMOVE_RESETPASSWORD",
  } ->
  exec { 'grant process':
    command => "mysql -u root --password=\'$::percona::root_password\' -e \"GRANT PROCESS ON *.* TO 'clustercheckuser'@'localhost' IDENTIFIED BY 'CLUSTERCHECK_PWD'; FLUSH PRIVILEGES;\"",
    path    => [ '/bin', '/usr/bin' ],
    require => Service["mysql@bootstrap.service"],
    unless  => "test -f ${percona::datadir}/DO_NOT_REMOVE_RESETPASSWORD",
  }  ->
  # MAKE SURE THIS FILE EXISTS
  file {"${percona::datadir}/DO_NOT_REOVE_RESETPASSWORD":
           path     => "${percona::datadir}/DO_NOT_REMOVE_RESETPASSWORD",
           ensure  => "present" ,
           content => "DO NOT REMOVE THIS FILE, THIS FILE IS USED BY PUPPET TO IDENTIFY IF THIS HOST NEEDS MYSQL SYSTEM USERS PASSWORD RESETS DURING SETUP" ,
  }
}
