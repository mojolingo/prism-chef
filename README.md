# DESCRIPTION:
  Configures Voxeo's Prism voice application server

# REQUIREMENTS:

  The cookbook by default comes with no license file, which means you only get the default 2 port license.  If you need a larger licese for evaluation purposes please contact Voxeo Labs and we would be more then happy to get you an evaluation license.

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


# Helpers aliases

### Prism Helpers
    ./ptime   # Prism running time
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

[2.4.0]
   * Use external server to determine IP if no other option works
   * NAT mode is not configurable via node[:prism][:natmode] attribute

[2.4.1]
   * Patches to init.d script

[2.5.0]
   * Changed default bosh url to be http-bind

[2.6.0]
   * Added additional logging for installer resource
   * Fix SIPoint and Tropo installer method in Prism library
   * Changed default username for RMI and MC to voxeolabs/voxeolabs
   * Change edit alias ( pec, pec, ect ) to use VI reather then VIM
   * Change OSGI Attribute name
[2.7.0]
   * Updated default prism build to prism-11_5_3_C201207041614_0-x64.bin
   * Fixed installer options, guess it needs double quotes
   * Updated conversion patterns on log4j
   * Fix include_tropo_logger setting, not correctly searchs role to see if Tropo is included
   * Now only a single syslog attribute.  This controls VXLuanch, log4j, and VCS syslog appenders
   * VXLaunch now takes an array of "extra_services", eg rtmpd and panda

[2.8.0]
   * Switched from nokogiri to rexml/document for XML parsing
   * Guards around node search in attributes file.  We use this to determin if Tropo is present.

[2.8.1]
   * Only use a licnese.lic file if defined [internal use only]
   * by default don't delete the prism demo application
   * Dry'ed up a few blocks related to voxeo-as,voxeo-ms, and voxeo-smanager.
   * Fix foodcritic FC24
   * Fix FC01 error

[2.8.2]
   * Renamed voxeo.sh alias file to prism.sh
   * Added default 4 port license file (Prism <= 12.x) [AUTOMATION-99]
   * Removed Artifacts cookbook dependency

[2.8.3]
   * Remove net/http method in library, need to look into why thats failing but just went w/ curl for a short term fix

