# Docker Registry: Secure Containerized Deployment

Secure Docker Registry Container using nginx, htpasswd and ssl.

## Usage
```sh
# create config directory
mkdir $(pwd)/config && chcon -Rt svirt_sandbox_file_t $(pwd)/config

# generate cert
docker run -it -v $(pwd)/config:/config alectolytic/secure-registry cert

# generate htaccess file
docker run -it -v $(pwd)/config:/config secure-registry htpasswd ${REGISTRY_USER} [${REGISTRY_USER_PASS}]

# start registry
docker run -d -v $(pwd)/config:/config -e SERVER_NAME=localhost -p 443:443 --name secure-registry
```
## References
* http://container-solutions.com/2015/04/running-secured-docker-registry-2-0/
* https://docs.docker.com/registry/
