# afraid6.tcl
# Updates your dynamic AAAA record in freedns.afraid.org.
# Should work with any decent DDNS provider that supports quad-A with very few code changes.
# Tested on Embedded Event Manager Version 3.00 (Cisco IOS 12.4(24)T8)

::cisco::eem::event_register_none maxrun 15 queue_priority low nice 0

namespace import ::cisco::eem::*
namespace import ::cisco::lib::*

# -- Set vars here --
# You can use short interface names (Fa0, Gi0/1, Di0) for $int
set int "Dialer0"
# Also update the set url "" statement a few lines below with your own base64 string

puts stdout "Looking for this router's global unicast IPv6 address..."
# Open CLI
if [catch {cli_open} result] {error $result $errorInfo} else {array set cli $result}
# Enable
if [catch {cli_exec $cli(fd) "enable"} result] {error $result $errorInfo}
# Run show ipv6 interface X
if [catch {cli_exec $cli(fd) "show ipv6 interface $int"} result] {error $result $errorInfo} else {set clioutput $result}
regexp {Global unicast.*subnet{1}} $clioutput x
regexp {(([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{1,4})} $x v6addr
puts stdout "Global unicast v6 is: $v6addr ($int)"

# DNS record update "secret" URL
set url "http://freedns.afraid.org/dynamic/update.php?base64HashHashHash==&address=$v6addr"

puts stdout "Updating AAAA record on freedns.afraid.org..."
puts $url
if {[catch {http::geturl $url -queryblocksize 50 -type "text/plain" } token]} {
        puts stdout "DDNS update failed. Can't get to URL. Maybe ip domain-lookup is turned off?"
} else {
        puts stdout "freedns.afraid.org DDNS response: [http::data $token]"
        }

exit 0
