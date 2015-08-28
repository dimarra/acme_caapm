# == Class: acme_caapm
#
# Full description of class acme_caapm here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'acme_caapm':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class acme_caapm (
    $pg_ssl                  = false,
    $postgres_dir            = undef,
    $db_host                 = 'localhost',
    $ssl_dir                 = undef,
    $ssl_ciphers             = 'ALL:!ADH:!LOW:!EXP:!MD5:@STRENGTH',
    $ssl_filename            = undef,
    $ssl_cert_file           = 'server.crt',
    $ssl_key_file            = 'server.key',
    $ssl_ca_file             = '',
    $ssl_crl_file            = '',
    
    $keystore_file           = 'internal/server/keystore',
    $keystore_passwd         = 'password',
    $keytool                 = 'jre/bin/keytool',
    $user_install_dir        = '/var/caapm/test/',
    $owner                   = undef,
    $group                   = undef,
    $mode                    = undef,
  
) {

    file { $ssl_dir:
      ensure  => 'directory',
      owner   => $owner,
      group   => $group,
      mode    => $mode,
    }

}
