afraid6.tcl
===========

Cisco EEM TCL script to update your router's AAAA dynamic DNS record with freedns.afraid.org.
By default afraid.org will also update your A record in one go.

Add this to your Event Manager configuration. Replace interface name.
```
  !
  event manager policy afraid6.tcl type user
  !
  event manager applet afraid6
    event syslog occurs 1 pattern "Interface Virtual-Access.*state to up"
    action 1.0 policy afraid6.tcl
  !
```
