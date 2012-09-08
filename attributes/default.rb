class Chef::Recipe
  include Prism
end

#
# GENERAL
##############################################
default['prism']['user']    = "voxeo"
default['prism']['group']   = "voxeo"

default['prism']['artifacts']['url']       =  "https://prism-app-server.s3.amazonaws.com/daily/prism-11_5_3_C201207041614_0-x64.bin"
default['prism']['artifacts']['checksum']  =  'c26ce756ff20bd3df7405d8f1e111e13a0c917186d596e6598dddbd3f0219e9a'


# By default we want to keep from installing tropo and sipoint
default['prism']['install_sip_point']     =  false
default['prism']['install_tropo']         =  false

default['prism']['default_home']          =  "/console/Prism.jsp"
#
# Init.d stuff
##############################################
default['prism']['path']['base']           =  "/opt/voxeo"
default['prism']['path']['prism']          =  "#{node['prism']['path']['base']}/prism"
default['prism']['pid']                   =  "/var/run"
default['prism']['lock']                  =  "/var/lock/subsys"

# Tropo in a box stuff
default['prism']['hosted_dir_listings']   =  false
default['prism']['enable_webhosting']     =  false
default['prism']['cust_home']             =  "/custhome"

# VXLAUNCH.XML SECTION
##############################################
default['prism']['runtime_mode']                               =  "server"

default['prism']['VxLaunch']['extra_services']                 =  []

default['prism']['VxLaunch']['http_control_port']              =  10086

default['prism']['ld_library_extras']                          =  []
default['prism']['VxLaunch']['as']['cache']                    =  60
default['prism']['VxLaunch']['as']['default_read_timeout']     =  60000
default['prism']['VxLaunch']['as']['default_connect_timeout']  =  60000

## NAT MAPPING STUFF
# This is used for nat mapping config, if not using please leave set to nil

default['prism']['osgi_enabled']                                 =  false
default['prism']['vcs']['check_packet_source']                   =  true

if node['ec2']
  default['prism']['nat_mode']                                   =  true
  default['prism']['local_ipv4']                                 =  node['ec2']['local_ipv4']
  default['prism']['public_ipv4']                                =  node['ec2']['public_ipv4']
elsif node.attribute?('openstack')
  default['prism']['nat_mode']                                   =  true
  default['prism']['local_ipv4']                                 =  node['ipaddress']
  default['prism']['public_ipv4']                                =  node['openstack']['public_ipv4']
else
  default['prism']['nat_mode']                                   =  false
  default['prism']['local_ipv4']                                 =  node['ipaddress']
  default['prism']['public_ipv4']                                =  Prism.get_public_ipv4
end

default['prism']['as']['rmi_username']                           =  "voxeolabs"
default['prism']['as']['rmi_password']                           =  "voxeolabs"

default['prism']['relay_port']                                   =  5060

default['prism']['netmask']                                      =  begin
  node['network']['interfaces'][node['network']['default_interface']]['addresses'][node['ipaddress']]['netmask']
rescue Exception => e
  "255.255.255.0"
end

#
# Log section of vxlaunch.xml
##############################################
default['prism']['VxLaunch']['Log']['max_file_size']                =  5242880
default['prism']['VxLaunch']['Log']['max_num_of_files']             =  10

#
# App Server (debug) section of vxlaunch.xml
##############################################

default['prism']['VxLaunch']['Commands']['as_debug']['OpenFileMax']  =  32678
default['prism']['VxLaunch']['Commands']['as_debug']['Xms']          =  "1g"
default['prism']['VxLaunch']['Commands']['as_debug']['Xmx']          =  "1g"
default['prism']['VxLaunch']['Commands']['as_debug']['MaxPermSize']  =  "512m"

default['prism']['VxLaunch']['debug_logging']                        =  false
#
# App Server section of vxlaunch.xml
##############################################
default['prism']['VxLaunch']['Commands']['as']['OpenFileMax']        =  32678
default['prism']['VxLaunch']['Commands']['as']['Xms']                =  "1g"
default['prism']['VxLaunch']['Commands']['as']['Xmx']                =  "1g"
default['prism']['VxLaunch']['Commands']['as']['MaxPermSize']        =  "512m"

#
# portappmapping.properties
##############################################
default['prism']['portAppMappings']={}

#
# sipmethod.xml
##############################################
default['prism']['sipmethod']['NetworkAccessPoint']['udp']          =  ["5060",'5061']
default['prism']['sipmethod']['NetworkAccessPoint']['tcp']          =  ["5060",'5061']

default['prism']['xmpp_client_port']                                =  5222
default['prism']['xmpp_server_port']                                =  5269
default['prism']['http_port']                                       =  8080
default['prism']['use_loop_back_address']                           =  false
default['prism']['cluster']                                         =  false
default['prism']['cluster_peers']                                   =  []

default['prism']['sipmethod']['phono_interceptor']['enabled']       =  false
default['prism']['sipmethod']['bosh']['enabled']                    =  false
default['prism']['sipmethod']['bosh']['url']                        =  "/http-bind"
#
# sipmethod-users.xml
##############################################
default['prism']['sipmethod_users']['admin_username']               =  "voxeolabs"
default['prism']['sipmethod_users']['admin_password']               =  "voxeolabs"
default['prism']['sipmethod_users']['number_of_test_users']         =  5
#
# sipenv.properties
##############################################
default['prism']['rmi_port']                                        =  47520

#
# autostart.properties
##############################################
default['prism']['autostart']['as']  =  true
default['prism']['autostart']['ms']  =  true

#
# CONFIG.XML SECTION
##############################################

default['prism']['vcs']['dns_servers']                              =  ["127.0.0.1:9962"]

default['prism']['vcs']['smtp_server']                              =  ""
default['prism']['vcs']['smtp_port']                                =  "25"
default['prism']['vcs']['allow_local_file_access']                  =  1

default['prism']['config']['Rtp']['BasePort']                       =  20000
default['prism']['config']['Rtp']['PayloadSize']                    =  160
default['prism']['config']['Rtp']['SocketBuffer']                   =  10000
default['prism']['config']['Rtp']['DTMFDuration']                   =  120
default['prism']['config']['Rtp']['DTMFPause']                      =  240

default['prism']['vcs']['sdp_parser_page_size']                     =  nil
default['prism']['vcs']['initial_rtp_clients_count']                =  nil

default['prism']['vcs']['conference_manager_url']                   =  "http://127.0.0.1:8080/com.voxeo.directory/"

default['prism']['config']['AGS1']['HTTPCtrlPort']                  =  10099

default['prism']['config']['TTS']['Cache']['DiskCache']             =  "#{node['prism']['path']['prism']}/Cache/TTS"
default['prism']['config']['TTS']['Cache']['DiskCacheSize']         =  "100"
default['prism']['config']['TTS']['Cache']['MemoryCacheSize']       =  0
default['prism']['config']['TTS']['Cache']['MaxItems']              =  4096
default['prism']['config']['TTS']['DefaultVoice']                   =  'en-us'

default['prism']['config']['TTS']['im']['Server']                   =  ["rtsp://127.0.0.1:2554/media/speechrecognizer/"]

default['prism']['config']['TTS']['FailoverGroup1']                 =  ["English-Female4"]
default['prism']['config']['TTS']['VoiceMappings']                  =  [
                                                                      {:voice=>"English-SAPI",:mapping=>"English-Female4"},
                                                                      {:voice=>"en-us",:mapping=>"English-Female4"}
                                                                    ]

# Off-box TTS Engines
default['prism']['tts_engines']                                     =  []

# OffBox ASR Engines
default['prism']['asr_engines']    =  [
                                      {:lang  =>  "en-us",:engine  =>  "vxsrepr"}
                                    ]

case node['platform']
  when "mac_os_x" then default['prism']['config']['TTS']['platform']  =  "osx"
  when "redhat","centos", "amazon","scientific","ubuntu" then default['prism']['config']['TTS']['platform']  =  "linux"
end

#default["prism"]["config"]["MRCPSRV"]["IP"]="0.0.0.0"

default['prism']['mrcp']['port']                                    =  10074
default['prism']['mcrp']['force_call_recording_debug']              =  false
default['prism']['mcrp']['listen_ip']                               =  "0.0.0.0"
default['prism']['mcrp']['log_level']                               =  8

default['prism']['vcs']['proxies']                                  =  []

default['prism']['vcs']['file_base']                                =  "./logs/vcs/log"
default['prism']['vcs']['max_number_of_files']                      =  100
default['prism']['vcs']['max_file_size']                            =  104857600


default['prism']['config']['Rtp']['SDPCodecs']                      =  []
default['prism']['config']['Rtp']['BasePort']                       =  20000
default['prism']['config']['Rtp']['PayloadSize']                    =  160
default['prism']['config']['Rtp']['SocketBuffer']                   =  10000
default['prism']['config']['Rtp']['DTMFDuration']                   =  120
default['prism']['config']['Rtp']['DTMFPause']                      =  240


# Prism AS Log4j config
if Chef::Config[:solo]
  default['prism']['include_tropo_logger']                          =  !node.run_list.expand("_default","disk").recipes.select{|x| x=~/tropo/}.empty?
else
  default['prism']['include_tropo_logger']                          =  !node.run_list.expand(node.chef_environment).recipes.select{|x| x=~/tropo/}.empty?
end


default['prism']['syslog_servers']                                  =  ["127.0.0.1:9977"]
default['prism']['log4j']['root_logger']                            =  %w(DEBUG FILE)
default['prism']['log4j']['syslog']['threshold']                    =  "DEBUG"
default['prism']['log4j']['syslog']['tcp']                          =  false
default['prism']['log4j']['append']                                 =  true
default['prism']['log4j']['max_file_size']                          =  '100MB'
default['prism']['log4j']['max_backup_index']                       =  30
default['prism']['log4j']['max_syslog_msg_size']                    =  nil


# When using a license.lic file you would define it here, this really is only applicable when using a super cool Voxeo unlocked license.  Generally licenses are bound to the machine.

default['prism']['license_file']                                    =  "license_4_ports.lic"

default['prism']['h2_bind_address']                                 =  "127.0.0.1"

default['prism']['delete_prism_demo']                               =  false
# SNMP Config
default['prism']['snmp_enabled']                                    =  false
default['prism']['snmp_tcp_listen_address']                         =  "0.0.0.0"
default['prism']['snmp_udp_listen_address']                         =  "0.0.0.0"
default['prism']['snmp_udp_port']                                   =  "12345"
default['prism']['snmp_tcp_port']                                   =  "1161"
default['prism']['community_name']                                  =  "prism.server"

# Sip Registration
default['prism']['registration_address']                            =  nil
default['prism']['registration_user']                               =  nil
default['prism']['registration_authuser']                           =  nil
default['prism']['registration_password']                           =  nil
default['prism']['registration_domain']                             =  nil
default['prism']['registration_contact']                            =  nil
default['prism']['gateway_address']                                 =  nil
default['prism']['gateway_transport']                               =  "udp"
default['prism']['registration_expiration']                         =  3600

