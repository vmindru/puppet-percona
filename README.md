puppet-percona
======

Puppet module for managing Percona XtraDB.

#### Table of Contents
1. [Overview](#overview)
2. [Module Description](#module-description)
    * [Parameters](#parameters)
3. [Starting Module](#starting-module)
4. [Document Percona Mysql](#document-percona-mysql)
5. [Requirements](#Requirements)
6. [Tested on](#tested-on)
7. [Usage with foreman](#usage-with-foreman)
    * [Donwload the module from git](#donwload-the-module-from-git)
    * [Import the module in foreman](#import-the-module-in-foreman)
8. [Configure the module with puppet](#configure-the-module-with-puppet)


##Overview

This module is intended to be used to manage the Percona XtraDB system configuration.
Percona XtraDB is an enhanced version of the InnoDB storage engine for MySQL® and MariaDB®.

##Module Description

The puppet module install and configure the client and server part of Percona XtraDB for Mysql.
The class has got this parameters:

###Parameters

The following parameters are supported:

* **percona_version**: the Percona mysql version to be used. Currently 5.5 5.6 [default: 5.5]
* **root_password**: the root password of the database [default: unset]
* **old_passwords**: set this to true to support the old mysql 3.x hashes for the passwords [default: false]
* **datadir**: the mysql data directory [default: /var/lib/mysql]
* **ist_recv_addr**: the IST receiver address for WSREP [default: ipaddress]
* **wsrep_max_ws_size**: the WSREP max working set size [default: 2G]
* **mysql_cluster_servers**: the string have to contains the ip or the fqan of the servers in the cluster parted by comma, like <ip1>,<ip2>,...
* **wsrep_cluster_address**: the WSREP cluster address list,It takes the value from the mysql_cluster_servers or you can set gcomm://<ip1>:4010,<ip2>:4010
* **wsrep_provider**: the WSREP provider [default: libgalera_smm.so]
* **wsrep_sst_receive_address**: the SST receiver address [default: ipaddress:4020]
* **wsrep_sst_user**: the WSREP SST user, used to auth [default: sstuser]
* **wsrep_sst_password**: the WSREP SST password, used to auth [default: sStus3r4020]
* **wsrep_sst_method**: the WSREP SST method, like rsync or xtrabackup [default: rsync]
* **wsrep_cluster_name**: the WSREP cluster name [default: clusterPercona]
* **binlog_format**: the binlog format [default: ROW]
* **default_storage_engine**: the default storage engine [default: InnoDB]
* **innodb_autoinc_lock_mode**: the innodb lock mode [default: 2]
* **innodb_locks_unsafe_for_binlog**: set this to true if you want to use unsafe locks for the binlogs [default: 1]
* **innodb_buffer_pool_size**: the innodb buffer pool size [default: 128M]
* **innodb_log_file_size**: the innodb log file size [default: 256M]
* **innodb_file_per_table**: set this to true to allow using sepafate files for the innodb tablespace [default: 1]
* **master**: set this to true to the first host in the cluster you are installing [default: false]


##Starting Module
We developed this module starting the:

* [De Salvo Puppet Percona Module](https://forge.puppetlabs.com/vmindru/percona)
* [Puppetlabs Mysql](https://forge.puppetlabs.com/puppetlabs/mysql)

##Module was forked from 

* https://github.com/desalvo/puppet-percona 

##Requirements

To use this module with all the cluster check you ha to install
* [xinetd](https://forge.puppetlabs.com/puppetlabs/xinetd)


##Document Percona Mysql:

* [Documentation Percona XtraDB](http://www.percona.com/software/percona-xtradb)


##Tested on

* CentOs 7
* RHEL & 

Module might work with adjustments on

* Centos 6 / RHEL 6 

##Usage with foreman only 

###Donwload the module from git
You have to clone the git repo, and then copy the percona directory in the puppet module directory used by formean puppetmaster host:

    $ git clone https://github.com/vmindru/puppet-percona.git
    $ cp -r percona /etc/puppet/environments/production/modules/

###Import the module in foreman

Inside foreman web application go to Configure -> Puppet classes
Push the import button. (Import from <puppetmester host>
Check the Add tips to percona line and click Import.

If you have not installed and imported xinetd yet, rembemer to:

* Install the module in puppet master host
```puppet module install puppetlabs-xinetd```
* Import the module
Push the import button. (Import from <puppetmester host>
Check the Add tips to xinetd line and click Import.


###Configure the module with your parameters:

You can change all the parameter you want in all the class. But the mandatory one is:
* In percona module set the mysql_cluster_servers. Theese are the node in mysql percona cluster. For example 192.168.10.20,192.168.10.21,192.168.10.22
* In percona module set wsrep_sst_method to xtrabackup-v2 , for some reason xtrabackup will be failing when clients will be joining master. 
* we also recomend to change default passwords 


###Assign to each host in the cluster the modules

* enter in host page. Choose the host designed to be part of mysql percona cluster
* Edit the host
* Go to Puppet classes
* Add the classes: xinetd percona
* For the first host in the cluster you are installing go to Parameters and overide the parameter Percona Master to true (just for first host) 
* Run puppet agent -t on the host, or wait 20 minutes puppet will run automaticaly.

Please note that in case you already have other DB machines in the cluster you will need to use the same value of innodb_log_file_size for all the components of the cluster.


