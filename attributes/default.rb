#
# GENERAL
##############################################
default[:prism][:user]    = "voxeo"
default[:prism][:group]   = "voxeo"

default[:prism][:artifacts][:url]       =  "https://prism-app-server.s3.amazonaws.com/release/prism-11_5_1_C201204261102_0-x64.bin"
default[:prism][:artifacts][:checksum]  =  'de15753d2f13af23964d70d620726895dd2d5c31d4f22df6e1ce2bd85a4c192e'

# By default we want to keep from installing tropo and sipoint
default[:prism][:install_sip_point]     =  false
default[:prism][:install_tropo]         =  false

#
# Init.d stuff
##############################################
default[:prism][:path][:base]           =  "/opt/voxeo"
default[:prism][:path][:prism]          =  "#{node["prism"]["path"]["base"]}/prism"
default[:prism][:pid]                   =  "/var/run"
default[:prism][:lock]                  =  "/var/lock/subsys"

# Tropo in a box stuff
default[:prism][:hosted_dir_listings]   =  false
default[:prism][:enable_webhosting]     =  false
default[:prism][:cust_home]             =  "/custhome"

# VXLAUNCH.XML SECTION
##############################################
default[:prism][:runtime_mode]                             =  "server"
default[:prism][:VxLaunch][:http_control_port]             =  10086

default[:prism][:VxLaunch][:rtmpd][:enabled]               =  false
default[:prism][:VxLaunch][:panda][:enabled]               =  false

default[:prism][:VxLaunch][:as][:cache]                    =  60
default[:prism][:VxLaunch][:as][:default_read_timeout]     =  60000
default[:prism][:VxLaunch][:as][:default_connect_timeout]  =  60000

## NAT MAPPING STUFF
# This is used for nat mapping config, if not using please leave set to nil
default[:prism][:nat_mode]              =  false
default[:prism][:osgi][:enabled]        =  false
default[:prism][:check_packet_source]   =  true
if node[:ec2]
  default[:prism][:nat_mode]            =  true
  default[:prism][:local_ipv4]          =  node[:ec2][:local_ipv4]
  default[:prism][:public_ipv4]         =  node[:ec2][:public_ipv4]
elsif node[:openstack]
  default[:prism][:nat_mode]            =  true
  default[:prism][:local_ipv4]          =  node.ipaddress
  default[:prism][:public_ipv4]         =  node[:openstack][:public_ipv4]
else
  default[:prism][:local_ipv4]          =  node.ipaddress
  default[:prism][:public_ipv4]         =  nil
end

default[:prism][:relay_port]            =  5060

default[:prism][:netmask]               =  begin
  node[:network][:interfaces][node[:network][:default_interface]][:addresses][node.ipaddress][:netmask] #=""
rescue Exception => e
  "255.255.255.0"
end

#
# Log section of vxlaunch.xml
##############################################
default[:prism][:VxLaunch][:Log][:max_file_size]                =  5242880
default[:prism][:VxLaunch][:Log][:max_num_of_files]             =  10
default[:prism][:VxLaunch][:Log][:syslog_servers]               =  ["127.0.0.1:9977"]

#
# App Server (debug) section of vxlaunch.xml
##############################################

default[:prism][:VxLaunch][:Commands][:as_debug][:OpenFileMax]  =  32678
default[:prism][:VxLaunch][:Commands][:as_debug][:Xms]          =  "1g"
default[:prism][:VxLaunch][:Commands][:as_debug][:Xmx]          =  "1g"
default[:prism][:VxLaunch][:Commands][:as_debug][:MaxPermSize]  =  "512m"

default[:prism][:VxLaunch][:debug_logging]                      =  false
#
# App Server section of vxlaunch.xml
##############################################
default[:prism][:VxLaunch][:Commands][:as][:OpenFileMax]        =  32678
default[:prism][:VxLaunch][:Commands][:as][:Xms]                =  "1g"
default[:prism][:VxLaunch][:Commands][:as][:Xmx]                =  "1g"
default[:prism][:VxLaunch][:Commands][:as][:MaxPermSize]        =  "512m"

#
# portappmapping.properties
##############################################
default[:prism][:portAppMappings]={} #"tropo"=>[6060]}

#
# sipmethod.xml
##############################################
default[:prism][:sipmethod][:NetworkAccessPoint][:udp]          =  ["5060",'5061']
default[:prism][:sipmethod][:NetworkAccessPoint][:tcp]          =  ["5060",'5061']

default[:prism][:xmpp_client_port]                              =  5222
default[:prism][:xmpp_server_port]                              =  5269
default[:prism][:http_port]                                     =  8080
default[:prism][:use_loop_back_address]                         =  false
default[:prism][:cluster]                                       =  false
default[:prism][:cluster_peers]                                 =  []

default[:prism][:sipmethod][:phono_interceptor][:enabled]       =  false
default[:prism][:sipmethod][:bosh][:enabled]                    =  false

#
# sipmethod-users.xml
##############################################
default[:prism][:sipmethod_users][:admin][:username]            =  "admin"
default[:prism][:sipmethod_users][:admin][:password]            =  "admin"
default[:prism][:sipmethod_users][:number_of_test_users]        =  5
#
# sipenv.properties
##############################################
default[:prism][:rmi_port]                                      =  47520

#
# autostart.properties
##############################################
default[:prism][:autostart][:as]  =  true
default[:prism][:autostart][:ms]  =  true

#
# CONFIG.XML SECTION
##############################################

default[:prism][:config][:DNS]                                  =  ["127.0.0.1:9962"]
default[:prism][:config][:IO][:SMTPServer]                      =  ""
default[:prism][:config][:IO][:SMTPPort]                        =  "25"
default[:prism][:config][:IO][:Proxys]                          =  ""
default[:prism][:config][:IO][:AllowLocalFileAccess]            =  1

default[:prism][:config][:Rtp][:BasePort]                       =  20000
default[:prism][:config][:Rtp][:PayloadSize]                    =  160
default[:prism][:config][:Rtp][:SocketBuffer]                   =  10000
default[:prism][:config][:Rtp][:DTMFDuration]                   =  120
default[:prism][:config][:Rtp][:DTMFPause]                      =  240

default[:prism][:sdp_parser_page_size]                          =  nil
default[:prism][:initial_rtp_clients_count]                     =  nil

default[:prism][:config][:Media][:ConferenceManagerURL]         =  "http://127.0.0.1:8080/com.voxeo.directory/"

default[:prism][:config][:Log][:FileBase]                       =  "./logs/vcs/log"
default[:prism][:config][:Log][:SysLogServer]                   =  ""
default[:prism][:config][:Log][:MaxNumOfFiles]                  =  100
default[:prism][:config][:Log][:MaxFileSize]                    =  104857600

default[:prism][:config][:AGS1][:HTTPCtrlPort]                  =  10099

default[:prism][:config][:ASR][:EngineMappings]                 =  [
                                                                     {:lang=>"dtmf",:engine=>"vxsredtmf"},
                                                                     {:lang=>"en-us",:engine=>"vxsrepr"}
                                                                   ]

default[:prism][:config][:ASR][:vxsremrcp]                       =  ""

default[:prism][:config][:TTS][:Cache][:DiskCache]               =  "#{node["prism"]["path"]["prism"]}/Cache/TTS"
default[:prism][:config][:TTS][:Cache][:DiskCacheSize]           =  "100"
default[:prism][:config][:TTS][:Cache][:MemoryCacheSize]         =  0
default[:prism][:config][:TTS][:Cache][:MaxItems]                =  4096
default[:prism][:config][:TTS][:DefaultVoice]                    =  'en-us'

default[:prism][:config][:TTS][:im][:Server]                     =  ["rtsp://127.0.0.1:2554/media/speechrecognizer/"]

default[:prism][:config][:TTS][:FailoverGroup1]                  =  ["English-Female4"]
default[:prism][:config][:TTS][:VoiceMappings]                   =  [
                                                                      {:voice=>"English-SAPI",:mapping=>"English-Female4"},
                                                                      {:voice=>"en-us",:mapping=>"English-Female4"}
                                                                    ]

case node['platform']
  when "mac_os_x"
    default[:prism][:config][:TTS][:platform]  =  "osx"
  when "redhat","centos", "amazon","ubuntu"
    default[:prism][:config][:TTS][:platform]  =  "linux"
end


#default["prism"]["config"]["MRCPSRV"]["IP"]="0.0.0.0"

default[:prism][:mrcp][:port]                                    =  10074
default[:prism][:mcrp][:listen_ip]                               =  "0.0.0.0"
default[:prism][:mcrp][:log_level]                               =  8

default[:prism][:config][:IO][:Proxys]                           =  []
default[:prism][:config][:Log][:SysLogServer]                    =  ['localhost:9977']
default[:prism][:config][:ASR][:vxsremrcp]                       =  []

default[:prism][:config][:Rtp][:SDPCodecs]                       =  []
default[:prism][:config][:Rtp][:BasePort]                        =  20000
default[:prism][:config][:Rtp][:PayloadSize]                     =  160
default[:prism][:config][:Rtp][:SocketBuffer]                    =  10000
default[:prism][:config][:Rtp][:DTMFDuration]                    =  120
default[:prism][:config][:Rtp][:DTMFPause]                       =  240

default[:prism][:log4j][:syslog][:server]                        =  "127.0.0.1:9977"
default[:prism][:log4j][:root_logger]                            =  %w(DEBUG FILE SYSLOG)
default[:prism][:log4j][:logger][:voxeo]                         =  %w(DEBUG FILE_APP SYSLOG)

default[:prism][:log4j][:syslog][:threshold]                     =  "DEBUG"
default[:prism][:log4j][:syslog][:tcp]                           =  false

default[:prism][:log4j][:file][:append]                          =  true
default[:prism][:log4j][:file][:max_file_size]                   =  '100MB'
default[:prism][:log4j][:file][:max_backup_index]                =  30

default[:prism][:license_file]                                   =  "license_25_ports.lic"
