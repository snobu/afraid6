afraid6.tcl
===========

Cisco EEM TCL script to update your router's AAAA dynamic DNS record with <b>freedns.afraid.org</b>.
By default afraid.org will also update your A record in one go.

### Open <b>afraid6.tcl</b> and replace these two vars:
```
# You can use short interface names (Fa0, Gi0/1, Di0) for $int
set int "Dialer0"
[..]
# Your "secret" update URL. Replace "YOUR_BASE64_SECRET==".
set url "http://freedns.afraid.org/dynamic/update.php?YOUR_BASE64_SECRET==&address=$v6addr"
```

### Copy <b>afraid6.tcl</b> to your router's flash in the location specified by this line in your configuration:
```
event manager directory user policy "flash:/"
````

### Add this to your Event Manager section. Replace interface name if you're not using PPP-over-whatnot.
```
  !
  event manager policy afraid6.tcl type user
  !
  event manager applet afraid6
    event syslog occurs 1 pattern "Interface Virtual-Access.*state to up"
    action 1.0 policy afraid6.tcl
  !
```

### Test by doing a "shut/no shut" on the interface connected to the Internet. <b>"show log"</b> should come up with good news.
```
.Jan 22 16:01:55: %HA_EM-6-LOG: afraid6.tcl: Looking for this router's global unicast IPv6 address...
.Jan 22 16:01:55: %HA_EM-6-LOG: afraid6.tcl: Global unicast v6 is: 2A02:2F0B:203F:FFFF::BC1A:B345 (Dialer0)
.Jan 22 16:01:55: %HA_EM-6-LOG: afraid6.tcl: Updating AAAA record on freedns.afraid.org...
.Jan 22 16:01:56: %HA_EM-6-LOG: afraid6.tcl: freedns.afraid.org DDNS response: 
                                             Updated 2 host(s) ipv6.example.org,
                                             ipv4.example.org in 0.041 seconds
```


"I honestly forgot why i'm here. Care to remind me?"

You are trying to update your AAAA record by going over IPv4, so you need to pass the IPv6 address as a parameter.
Relax though, all this will become obsolete when <b>freedns.afraid.org</b> is reachable over v6.
Then you'll only need to "GET" the secret update URL, just like you do for your dynamic A record on v4.

```
No quad-A record yet.

$ dig +short a freedns.afraid.org
204.140.20.22
$ dig +short aaaa freedns.afraid.org
$
```
