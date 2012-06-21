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

    node[:prism][:gateway_address],
    node[:prism][:gateway_transport],
    node[:prism][:registration_address],
    node[:prism][:registration_enabled],
    node[:prism][:registration_user],
    node[:prism][:registration_address],
    node[:prism][:registration_authuser],
    node[:prism][:registration_password],
    node[:prism][:registration_domain],
    node[:prism][:registration_contact],
    node[:prism][:registration_expiration],

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

