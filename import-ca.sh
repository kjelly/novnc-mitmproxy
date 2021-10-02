#!/bin/bash

wget -t 0 --retry-connrefused -e http_proxy=127.0.0.1:8080 -e use_proxy=yes http://mitm.it/cert/pem -O /tmp/mitmproxy.pem

certutil -d sql:$HOME/.pki/nssdb -A -t 'C,,' -n mitmproxy -i /tmp/mitmproxy.pem
