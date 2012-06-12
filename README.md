= DESCRIPTION:

= REQUIREMENTS:

= ATTRIBUTES:


# Setting ASR Engines

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

= USAGE:

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

