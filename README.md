afraid6.tcl
===========

Cisco EEM TCL script to update your router's AAAA dynamic DNS record with freedns.afraid.org.
By default afraid.org will also update your A record in one go.

1. Copy afraid6.tcl to your router's flash in the location specified by this line in your configuration:
```
event manager directory user policy "flash:/"
````

2. Add this to your Event Manager section. Replace interface name if you're not using PPP-over-whatnot.
```
  !
  event manager policy afraid6.tcl type user
  !
  event manager applet afraid6
    event syslog occurs 1 pattern "Interface Virtual-Access.*state to up"
    action 1.0 policy afraid6.tcl
  !
```

3. Test by doing a "shut/no shut" on the interface connected to the Internet. "show log" should come up with good news.
```
.Jan 22 16:01:55: %HA_EM-6-LOG: afraid6.tcl: Looking for this router's global unicast IPv6 address...
.Jan 22 16:01:55: %HA_EM-6-LOG: afraid6.tcl: Global unicast v6 is: 2A02:2F0B:203F:FFFF::BC1A:B345 (Dialer0)
.Jan 22 16:01:55: %HA_EM-6-LOG: afraid6.tcl: Updating AAAA record on freedns.afraid.org...
.Jan 22 16:01:56: %HA_EM-6-LOG: afraid6.tcl: freedns.afraid.org DDNS response: Updated 2 host(s) ipv6.example.org, ipv4.example.org 69 in 0.041 seconds
```
