GOOS = $(shell uname)
LGOOS = $(shell echo $(GOOS) | tr A-Z a-z)

start: start-random start-alertmanager start-prometheus

start-random:
	./bin/random-$(LGOOS)-amd64 -listen-address=:8080 &
	./bin/random-$(LGOOS)-amd64 -listen-address=:8081 &
	./bin/random-$(LGOOS)-amd64 -listen-address=:8082 &

start-prometheus:
	./bin/prometheus-$(LGOOS)-amd64 &

start-alertmanager:
	./bin/alertmanager-$(LGOOS)-amd64 &

kill:
	killall prometheus-$(LGOOS)-amd64 alertmanager-$(LGOOS)-amd64 random-$(LGOOS)-amd64
