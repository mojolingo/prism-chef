set host  [lindex $argv 0]
set port  [lindex $argv 1]
set bean  [lindex $argv 2]
set item  [lindex $argv 3]
jmx_connect -s service:jmx:rmi:///jndi/rmi://$host:$port/rmi
set session_count [jmx_get -m $bean $item]

puts "$session_count"

jmx_close
