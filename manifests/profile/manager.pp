# 
# == Class: acme_caapm::profile::manager
#
# This profile configures the defaults for a Manager of Managers (MOM) Enterprise Manager 
#

class acme_caapm::profile::manager inherits acme_caapm {
  
  contain caapm::em::config
  
  notify {"Running with acme_caapm::profile::manager":}
  
  if $pg_ssl {
  
      Openssl::Certificate::X509 <<| tag == "${::cluster}-apmdb" |>>

      @@openssl::certificate::x509 { "${::cluster}-${::role}-${hostname}":
        ensure       => present,
        country      => 'AU',
        organization => 'diamond.org',
        commonname   => $fqdn,
        state        => 'VIC',
        locality     => 'Melbourne',
        unit         => 'Technology',
#        altnames     => ["DNS.1:*.${domain}"],
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

      Openssl::Certificate::X509 <<| tag == "${::cluster}-${::role}" |>>
      Java_ks <<| tag == "${::cluster}-keystore" |>>
      


# how about the chain option?
# how about the private key?
# import the database certificate
      java_ks { "${::cluster}-${::role}-${hostname}":
        ensure       => latest,
        certificate  => "${ssl_dir}/${::cluster}-${::role}-${db_host}.crt",
        target       => $keystore_file,
        password     => $keystore_passwd,
        trustcacerts => true,
      }

/* this may not really be needed
      java_ks { "${::cluster}-${::role}:${::keystore}":
        ensure       => latest,
        certificate  => "${ssl_dir}/${::cluster}-${::role}-${hostname}.crt",
        target       => "${ssl_dir}/${keystore_file}",
        password     => $keystore_passwd,
        trustcacerts => true,
      }
   */
   } 
}