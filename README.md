# Docker Registry: Secure Containerized Deployment

Secure Docker Registry Container using nginx, htpasswd and ssl.

## Usage
```sh
$ sudo docker run alectolytic/secure-registry:2.0.1 help

Usage:
 /usr/bin/entrypoint [<command>] [arguments]

Commands:
 gencert    Generate a self-signed certificate. Environment variables respected
            include: C=AU, ST=Queensland, L=Brisbane, O=Void,CN=$SERVER_NAME

 help       Display this message.

 htpasswd   Run htpasswd command to set username/password. Expectes username and
            password (if non-interactive) to be provided. Any additional options
            to use when generating/modifying /config/.htpasswd can be specified
            using the OPT environment variable.

 setup      Generate SSL cert and htpasswd; and extract all default confiuration
            to /config. When generating htpasswd file the default user docker
            is used if USERNAME env var is not set; and a random password is
            generated and stored in /config/.password if PASSWORD env var is not
            set or /config/.password is not provided.

 start      (DEFAULT) This command triggers a setup and starts the secure
            registry. The registry with configuration loaded from /config
            where available or generates initial config before start.
```

## Quickstarts

### Start registry on localhost

```sh
# create config directory
mkdir $(pwd)/config && chcon -Rt svirt_sandbox_file_t $(pwd)/config

# start registry (with username=docker and random password)
# once started see $(pwd)/config/.password for registry password for username:docker
docker run -d -v $(pwd)/config:/config -e SERVER_NAME=localhost -p 443:443 --name secure-registry
```

To specify credentials; start container with `-e USERNAME=crazy -e PASSWORD=fool`.

### Configuration

To customize configuration you can use the `setup` command to create initial configurations. This would allow you to modify where data is stored etc. See the [Docker Registry Configuration Reference](https://github.com/docker/distribution/blob/master/docs/configuration.md) and [Nginx Configuration](http://wiki.nginx.org/Configuration) for more information regarding component specific configurations.

#### Command
```sh
docker run -it -v $(pwd)/config:/config alectolytic/secure-registry:2.0.1 setup
```

#### Sample output
```
Generating a 4096 bit RSA private key
.........................++
.................................................................................................++
writing new private key to 'docker-registry.key'
-----
[INFO] PASSWORD=ax5CrRKaRS4qVMqkUPo60xPvW2VUSUPZr8nsfjzMNO8=
Adding password for user docker
/config
[abn@zoidberg docker-registry-secure (master)]$ tree -a config/
config/
├── docker-registry.crt
├── docker-registry.key
├── docker-registry.yml
├── .htpasswd
├── nginx.conf
└── .password


0 directories, 4 files
```

### Disposable Test instances
#### Command
```sh
docker run -it -p 443:443 alectolytic/secure-registry:2.0.1 start
```

#### Sample output
Note the line with `PASSWORD`.

```
Generating a 4096 bit RSA private key
.......................................................................++
............................................................................................++
writing new private key to 'docker-registry.key'
-----
[INFO] PASSWORD=s1bn3xBnvwkCi40tkYDwj71sM8v71Gy2IhpYkpOhF+I=
Adding password for user docker
/config
2015-06-12 02:43:45,537 CRIT Set uid to user 0
2015-06-12 02:43:45,539 INFO supervisord started with pid 35
2015-06-12 02:43:46,541 INFO spawned: 'nginx' with pid 38
2015-06-12 02:43:46,542 INFO spawned: 'registry' with pid 39
2015-06-12 02:43:47,569 INFO success: nginx entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
2015-06-12 02:43:47,569 INFO success: registry entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
```

### Makefile Targets

For convinience a Makefile is also provided. It provides the following targets.


| Target  | Description |
| ------------- | ------------- |
| build  | Builds from the current directory with the correct tag |
| tag_latest  | Tags the latest version build as the latest  |
| clean | Cleans up image from using rmi and removes the config directory |
| gencert | Runs the gencert command |
| htpasswd | Runs the htpasswd command |
| help | Shows the help document |
| start | Starts the registry with the volumes mounted |
| start-fg | Same as start, but do not detach |
| test | Starts the registry with the volumes not mounted (not persisted) |
| test-fg | Same as test but do not detach |
| shell | Start a bash shell in the container |
| $(pwd)/config | Create the configuration directory and apply `chcon` |

## References
* http://container-solutions.com/2015/04/running-secured-docker-registry-2-0/
* https://docs.docker.com/registry/
