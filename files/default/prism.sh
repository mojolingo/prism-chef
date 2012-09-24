#
# Helper Functions
####################

# Prism Runtime
function ptime() {
  echo $(ps aux | grep java  | grep -v grep | ps -o pid,etime,cmd `awk '{ print $2 }'` | grep -v ELAPSED | awk '{ printf("Prism has been running for %s\n", $2)}')
}

# VCS Runtime
function vtime() {
  echo $(ps aux | grep "bin/VCS"  | grep -v grep | ps -o pid,etime,cmd `awk '{ print $2 }'` | grep -v ELAPSED | awk '{ printf("VCS has been running for %s\n", $2)}')
}

# Prism Alias
function p() {
  /opt/voxeo/prism/bin/prism $1 $2 $3
}


#
# Config Alias
####################

function pes() {
  vi /opt/voxeo/prism/conf/sipmethod.xml
}

function pev() {
  vi /opt/voxeo/prism/conf/vxlaunch.xml
}

function pec() {
  vi /opt/voxeo/prism/conf/config.xml
}

# function pet() {
#   vi /opt/voxeo/prism/server/apps/tropo/WEB-INF/classes/tropo.xml
# }


#
# Log Functions
####################

# Tail VCS
function tvcs() {
  tail -f -n 50 `ls -tr /opt/voxeo/prism/logs/vcs/log* | tail -n 1` | sed 's/\\r\\n/\n/g'
}

# Tail SipMethod
function tsm() {
  tail -f /opt/voxeo/prism/logs/sipmethod.log
}

# Tail Wrapper
function tw() {
  tail -f /opt/voxeo/prism/logs/wrapper.log
}

