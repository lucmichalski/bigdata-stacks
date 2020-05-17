# warp rsync

## command **rsync**

`warp rsync push --all`

```bash
rsync: --chown=501:33: unknown option
rsync error: syntax or usage error (code 1) at /BuildRoot/Library/Caches/com.apple.xbs/Sources/rsync/rsync-52.200.1/rsync/main.c(1337) [client=2.6.9]
Completed copying all files from host to container
```

### possible solutions
- update rsync 
- minimum required version 3.1.1

-------------

## command **rsync**

`warp rsync push <file>`

```bash
Template parsing error: template: :1:3: executing "" at <index (index .NetworkSettings.Ports "873/tcp") 0>: error calling index: index of untyped nil
rsync: failed to connect to localhost (::1): Connection refused (61)
rsync: failed to connect to localhost (127.0.0.1): Connection refused (61)
rsync error: error in socket IO (code 10) at clientserver.c(127) [sender=3.1.3]
```

### possible solutions
- Check the file `docker-compose-warp.yml`, if you have the container `appdata` like this:

```yaml
  appdata:
    image: alpine:latest
```

Run the following command to restart all configuration, after that you will have correctly configured  container `appdata`

!!! warning
    You are going to delete all project settings    
    If you go ahead you must reconfigure the entire project

```bash
warp stop --hard
warp reset --hard
war init
warp start
```

-------------