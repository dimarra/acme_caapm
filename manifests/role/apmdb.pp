# 
# == Class:acme_caapm::role::apmdb
#
# This role designates the target as a APM Database
#
class acme_caapm::role::apmdb { 
  
  contain      caapm::profile::database
  contain acme_caapm::profile::database

# which splunk module do you want to use  
# include acme_splunk::profile::uforwarder
  
}