# Alertmanager + Pagerduty Deep Dive

- Download the latest Prometheus and Alertmanager binaries from [here](https://prometheus.io/download/). Prometheus 2.3.2, Alertmanager 0.15.2.
- Create a Pagerduty service with the default settings and an escalation policy that will notify you.
```
Incident Behavior: Create alerts and incidents
Alert Grouping Behavior: No alert grouping
```
Per the [integration guide](https://www.pagerduty.com/docs/guides/prometheus-integration-guide/):
```
Important note for Prometheus Alertmanager v0.11 and later: Alertmanager now supports Events API v2. However, if you set the routing_key property and use v2, the integration type of the integration corresponding to the routing_key value must also be Events API v2.
```
- Create an integration of type `Events API v2`. (`Use our API directly`) and note the key. Put the key in `alertmanager.yml` where it says `KEYGOESHERE`.
- Run `make start`. Hopefully this will start 3 http services that Prometheus will scrape, Prometheus, and Alertmanager.
- Verify at `localhost:9090/targets` that all three targets in `example` are being scraped, and that the alert at `localhost:9090/alerts` is green.
- Now kill one of the processes `random-<arch>-amd64` on your computer
- After 30 seconds or so, you should see the alert turn red on `localhost:9090/alerts`, and an alert will be sent that you can see in Alertmanager at `localhost:9093`
- That alert will go on to Pagerduty and you will get paged.
- Now, wait a minute or so, and kill a second `random-` process.
- Wait another minute, and then go and look at your incident, nothing new will have happened. But if you click to view the alert.
![https://i.imgur.com/ZWjcFOI.png](https://i.imgur.com/ZWjcFOI.png)
- Then scroll down you can see that a second alert with new context did in fact fire, but got deduped (read: blackholed), you can see the additional raw context if you click through here
![https://i.imgur.com/44ougnr.png](https://i.imgur.com/44ougnr.png)

In an ideal world, that new alert (with new context) would be added as a second alert on the incident. My suspicion however, is that most integrations sending alerts don't dedup (like alertmanager does) alerts,
so they implemented it this way in their events v2 api.
