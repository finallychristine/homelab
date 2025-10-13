#!/usr/bin/env python
from dataclasses import dataclass, asdict
from string import Template

@dataclass
class Proxy:
    name: str
    port: int = 80
    upstream_override: str = None
    subdomain_override: str = None
    insecure_https_upstream: bool = False

    def subdomain(self) -> str:
        if self.subdomain_override:
            return self.subdomain_override

        return self.name

    def upstream(self):
        if self.upstream_override:
            return f"{self.upstream_override}:{self.port}"

        return f"{self.name}.vip.bear-network:{self.port}"

    def upstream_scheme(self) -> str:
        if self.insecure_https_upstream:
            return "https"
        else:
            return "http"

    def dict(self):
        return {
            "name": self.name,
            "port": self.port,
            "upstream": self.upstream(),
            "upstream_scheme": self.upstream_scheme(),
            "subdomain": self.subdomain(),
            "insecure_https_upstream": self.insecure_https_upstream,
        }

proxies: list[Proxy] = [
    Proxy(name = "grafana"),
    Proxy(name = "influxdb2"),
    Proxy(name = "homeassistant", subdomain_override="ha", upstream_override="host.docker.internal", port=8123),
    Proxy(name = "alloy"),
    Proxy(name = "loki"),
    Proxy(name = "portainer", port=9000),
    Proxy(name = "wud", port=3000),
    Proxy(name = "plex", port=32400, upstream_override="host.docker.internal"),
    Proxy(name = "ddns", port=8000),
    Proxy(name = "rgb", port=27003),
    Proxy(name = "nas", port=5001, upstream_override="storage-den.vip.bear-network", insecure_https_upstream = True),
    Proxy(name = "backups", port=9898),
]

for proxy in proxies:
    tmpl = None
    with open("proxy.conf.tmpl") as f:
        tmpl = Template(f.read())
    result = tmpl.substitute(proxy.dict())
    with open(f"etcnginx/proxies.d/{proxy.name}.conf", "w") as f:
        f.write(result)
