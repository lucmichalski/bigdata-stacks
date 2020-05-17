## command **start**

`warp start`

```bash
ERROR: for test_php_1  Cannot start service php: OCI runtime create failed: container_linux.go:346: 
starting container process caused "process_linux.go:449: container init caused \"rootfs_linux.go:58: mounting \\\"/Users/matias/Desktop/test/.warp/docker/config/php/ext-ioncube.ini\\\" to rootfs \\\"/var/lib/docker/overlay2/4f3d14d1f3d7755705914496fd518389d2510081d6d1f0e1e41155da236c638b/merged\\\" at \\\"/var/lib/docker/overlay2/4f3d14d1f3d7755705914496fd518389d2510081d6d1f0e1e41155da236c638b/merged/usr/local/etc/php/conf.d/10-php-ext-ioncube.ini\\\" caused \\\"not a directory\\\"\"": 
unknown: Are you trying to mount a directory onto a file (or vice-versa)? Check if the specified host path exists and is the expected type

ERROR: for php  Cannot start service php: OCI runtime create failed: container_linux.go:346: starting container process caused "process_linux.go:449: container init caused \"rootfs_linux.go:58: mounting \\\"/Users/matias/Desktop/test/.warp/docker/config/php/ext-ioncube.ini\\\" to rootfs \\\"/var/lib/docker/overlay2/4f3d14d1f3d7755705914496fd518389d2510081d6d1f0e1e41155da236c638b/merged\\\" at \\\"/var/lib/docker/overlay2/4f3d14d1f3d7755705914496fd518389d2510081d6d1f0e1e41155da236c638b/merged/usr/local/etc/php/conf.d/10-php-ext-ioncube.ini\\\" caused \\\"not a directory\\\"\"": 
unknown: Are you trying to mount a directory onto a file (or vice-versa)? Check if the specified host path exists and is the expected type
ERROR: Encountered errors while bringing up the project.
ERROR: No container found for php_1
Error response from daemon: mount /Users/matias/Desktop/test/.warp/docker/config/php/ext-ioncube.ini:/var/lib/docker/overlay2/4f3d14d1f3d7755705914496fd518389d2510081d6d1f0e1e41155da236c638b/merged/usr/local/etc/php/conf.d/10-php-ext-ioncube.ini, flags: 0x5000: not a directory
ERROR: No container found for php_1
```

### possible solutions
- Are you trying to mount a directory onto a file (or vice-versa)
- Check the mapped files in `docker-compose-warp.yml`, if the files do not exist, they are created as directories.

In this case, run the following commands:

```bash
warp stop --hard
warp reset
warp init
warp start
```

> some configuration files are created from .samples files

-------------

## command **start**

`warp start`

```
ERROR: for web  Cannot start service web: b'driver failed programming external connectivity on endpoint somesite-m2_web_1 (a24e3b084b74c2bfed4452eae4d1d837be4644565041c76ba4941899336ecf85): Error starting userland proxy: Bind for 0.0.0.0:80: unexpected error (Failure EADDRINUSE)'
ERROR: Encountered errors while bringing up the project.
``` 

### possible solutions
- check apache or nginx is working on port 80/443
