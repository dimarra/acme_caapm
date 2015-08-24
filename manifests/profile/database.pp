# 
# == Class: acme_caapm::profile::database
#
# This profile configures the defaults for the PostgreSQL APM DB 
#
class acme_caapm::profile::database inherits acme_caapm  { 

  contain caapm::database
  
  notify {"Running with acme_caapm::profile::database = $pg_ssl":}
  
  
  if $pg_ssl {

    file { $ssl_dir:
      ensure  => 'directory',
      owner   => $owner,
      group   => $group,
      mode    => $mode,
    }

    file_line { 'enable_ssl':
      path    => "${postgres_dir}/data/postgresql.conf",
      line    => "ssl = on                                                # enabled by Puppet to secure CA APM Database",
      match   => ".*ssl = .*$",
    }

    file_line { 'set_ssl_key_file':
      path    => "${postgres_dir}/data/postgresql.conf",
      line    => "ssl_key_file = '${ssl_dir}/${::cluster}-${::role}-${hostname}.key'                            # modified by Puppet to secure CA APM Database",
#      line    => "ssl_key_file = '${ssl_dir}/${ssl_key_file}'                            # modified by Puppet to secure CA APM Database",
      match   => ".*ssl_key_file = .*$",
    }

    file_line { 'set_ssl_cert_file':
      path    => "${postgres_dir}/data/postgresql.conf",
      line    => "ssl_cert_file = '${ssl_dir}/${::cluster}-${::role}-${hostname}.crt'                           # modified by Puppet to secure CA APM Database",
      match   => ".*ssl_cert_file = .*$",
    }

    file_line { 'set_ssl_ciphers':
      path    => "${postgres_dir}/data/postgresql.conf",
      line    => "ssl_ciphers = '${ssl_ciphers}'                           # modified by Puppet to secure CA APM Database",
      match   => ".*ssl_ciphers = .*$",
    }


    file_line { 'set_client_auth':
      path    => "${postgres_dir}/data/pg_hba.conf",
      line    => "hostssl all         all         127.0.0.1/32          cert",
      match   => "^host.*127.0.0.1/32.*",
    }

# review automatic data bindings to populate this via common.yaml
# how do you double interpolate?
    @@openssl::certificate::x509 { "${::cluster}-${::role}-${hostname}":
      ensure       => present,
      country      => 'AU',
      organization => 'diamond.org',
      commonname   => $fqdn,
      state        => 'VIC',
      locality     => 'Melbourne',
      unit         => 'Technology',
#      altnames     => ["DNS.1:*.${domain}"],
      email        => 'raul.dimar@gmail.com.au',
      days         => 3456,
      base_dir     => $ssl_dir,
      owner        => $owner,
      group        => $group,
      force        => false,
      cnf_tpl      => 'openssl/cert.cnf.erb',
      require      => File [$ssl_dir],
      tag          => "${::cluster}-${::role}"
    }
    
    
    @@java_ks { "${::cluster}-${::role}-${hostname}":
      ensure      => latest, 
      name        => 'accounting.dev.example.com',
      certificate => '/etc/ssl/certs/accounting.dev.example.com.crt',
      private_key => '/etc/ssl/private/accounting.dev.example.com.key',
      target      => "$ssl_dir/broker.jks',
      password    => 'not_so_secret',
      tag          => "${::cluster}-keystore"
    }



    Openssl::Certificate::X509 <<| tag == "${::cluster}-${::role}" |>>

  }


}