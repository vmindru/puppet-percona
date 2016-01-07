# == Class: percona::repo::yum
#
class percona::repo::yum {


  $releasever = split("${::operatingsystemrelease}", '[.]')

  yumrepo { 'percona':
    descr    => 'CentOS $releasever - Percona',
    baseurl  => "http://repo.percona.com/centos/${releasever[0]}/os/$architecture/",
    gpgkey   => 'http://www.percona.com/downloads/percona-release/RPM-GPG-KEY-percona',
    enabled  => 1,
    gpgcheck => 1,
  }

}
