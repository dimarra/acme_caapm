# 
# == Class: acme_caapm::role::mom
#
# This role designates the node as a MOM
#
class acme_caapm::role::mom { 
  

  include acme_caapm::profile::manager
  
# which splunk module do you want to use  
#  include acme_splunk::profile::uforwarder
  
  

  
}