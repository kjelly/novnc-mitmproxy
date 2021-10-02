# novnc-mitmproxy

## quickstart

```
docker build -t novnc-mitmproxy .
docker run -p 8801:8081 -p 5901:5901 -d -v /dev/shm:/dev/shm  --name mitmproxy --privileged novnc-mitmproxy
```
