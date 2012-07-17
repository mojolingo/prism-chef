# DESCRIPTION:
  Configures Voxeo's Prism voice application server

# REQUIREMENTS:

# ATTRIBUTES:


### Setting ASR Engines

    default[:prism][:asr_engines]    =   [
                                            {
                                              :lang  =>  "en-us",
                                              :engine  =>  "vxsrepr",
                                            },
                                            {
                                              "ignore_cseq_errors": true,
                                              "engine": "vxsremrcp",
                                              "lang": "en-us",
                                              "servers": [
                                                "rtsp://172.16.163.103:5554/recognizer",
                                                "rtsp://172.16.163.102:5554/recognizer"
                                              ]
                                            },
                                            {
                                              "ignore_cseq_errors": true,
                                              "engine": "vxsremrcp",
                                              "lang": "en-au",
                                              "servers": [
                                                "rtsp://172.16.163.103:5554/recognizer",
                                                "rtsp://172.16.163.102:5554/recognizer"
                                              ]
                                            }
                                          ]

##### Setting TTS Engines

    default[:prism][:tts_engines]     = [
                                        {
                                          "name"  =>  "allison",
                                          "lang"  =>  "en-us",
                                          "servers" => [
                                            "rtsp://172.25.163.103:5554/speechsynthesizer"
                                          ]
                                        },
                                        {
                                          "name"  => "dave",
                                          "lang"  => "en-us",
                                          "servers" => [
                                            "rtsp://172.25.163.103:5554/speechsynthesizer"
                                          ]
                                        },
                                        {
                                          "name"  => "susan",
                                          "lang"  => "en-us",
                                          "servers" => [
                                            "rtsp://172.25.163.103:5554/speechsynthesizer"
                                          ]
                                        }
                                      ]


##### Sip Registration

Prism supports sip regisration, and this is of course configurable via Chef.  The follow attributes are related to setting a SIP gateway and/or SIP registration

    node[:prism][:gateway_address]
    node[:prism][:gateway_transport]
    node[:prism][:registration_address]
    node[:prism][:registration_user]
    node[:prism][:registration_address]
    node[:prism][:registration_authuser]
    node[:prism][:registration_password]
    node[:prism][:registration_domain]
    node[:prism][:registration_contact]
    node[:prism][:registration_expiration]


##### RMI Config

 Prism supports configuration via Mbean, the default usernam and password for the rmi interface is admin/admin.

    node[:prism][:as][:rmi_username]
    node[:prism][:as][:rmi_password]


# USAGE:

Note:  Should include 2 port unlocked license with any public release


# Helpers

### Prism Helpers
    ./ptime   #Prism running time
    ./vtime   # VCS Runtime
    ./p       # Prism Alias eg: `p status`

### Config Helpers
    ./pes     # Edit Sipmethod.xml
    ./pev     # Edit vxlaunch.xml
    ./pec     # Edit config.xml
    ./pet     # Edit tropo.xml

### Log Helpers
    ./tvcs    # Tail Latest VCS log
    ./tsm     # Tail SipMethod
    ./tw      # Tail wrapper.log


# Change Log:

[1.2.1]

    * Added change log
    * SNMP port and service status is now configurable

[1.2.2]

    * Changed sipmethod console username and password atttribute name

[1.3.0]

    * New version numbers
    * Added sip registration to sipmethod.xml

[1.4.0]
    * No longer need to explicity enable "registration", instead we assume its enabled if you provided a gateway host attribute.  This is defaulted to false
    * Max log size is now nil, and not included in log4j.properties unless set

[1.5.0]
   * Bosh URL is now configurable
   * Force Call Recording is now configurable via chef

[1.6.0]
   * Refactor of attribute names ( start )

[1.7.0]
   * Refactor of logging config to support muitple log4j syslog appenders

[2.0.0]
   * Refactor cookbook recipes into single default.rb file

[2.1.0]
   * Added RMI config to chef

[2.2.0]
   * Added index.jsp to chef
   * Added delete_console to chef

[2.3.0]
   * Updated log4j conversion patterns
