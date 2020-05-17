# Vigie configuration

The entire Vigie config is a toml file.

!!! info "Vigie Config File example"
    Download an example of [`vigieconf.toml`](https://raw.githubusercontent.com/Vincoll/vigie/master/vigieconf.toml)

This config file is mandatory to launch Vigie. You can specify a path to this config file with :

`vigie run --config ./config/vigieconf_example.toml`

## Configuration file structure

#### Git

_Cannot pull from private repo yet (WIP)._

You can import your testfiles from a git repo.

```toml
[git]
  # Import Tests and Variables from a Git Repo
  # Vigie will clone this repo, then import it as usual
  # by adding the destination in [testfiles].included
  # Git clone is without the repo parent name folder
  
  # Enable the clone
  # Default : false
  # Format :  bool
  clone = true
  # Repo link
  # Default : ""
  # Format : "https://domain.tld/repo"
  repo = "https://github.com/Vincoll/vigie-demo-test"
  # Destination path  of the cloned repo 
  # Default : "/tmp/vigie"
  # Format :  "string"
  path = "/tmp/vigie"
```



#### TestFiles

List of directories or test files that will be imported into Vigie.

In case of directory, the file search is done in depth.


!!! tip "Git and Tests Path"
    Test from the Git repo will be cloned before the import, the destination directory of the clone must be added in `included`.

```toml
[testfiles]
  # Paths List of testfiles
  # Searching for files is done in depth.
  # Dir path and file path are both valid
  # Default : [""]
  # Format ["string", "string", ...]
  included = ["/tmp/vigie/test/"]

  # Paths or files to exclude (can be contained in included path)
  # Default : [""]
  # Format ["string", "string", ...]
  excluded = [""]

```

#### Variables

```toml
[variables]
  # Paths List of variables files
  # Searching for files is done in depth.
  # Dir path and file path are both valid
  # Default : [""]
  # Format ["string", "string", ...]
  included = ["/tmp/vigie/var/"]
```


### Log

```toml
[log]
  # Activate the log through stdout
  # Default : true
  # Format : bool
  stdout = true
  # Log into a file
  # Default : false
  # Format : bool
  logfile = false
  # Log level
  # Default : info
  # Valid values : "info","warn","error",debug,"trace"
  level = "info"
  # File to write logs into
  # Default : ""
  # Format : string
  filePath = "/tmp/vigie.log"

```

**Valid values for `log.level`** : `info`, `warn`, `error`, `debug`, `trace`

### API

```toml
[api]
  # Activate the API
  # Default : true
  # Format : bool
  enable = true
  # API exposed port
  # Default : 80
  # Format : int 
  port = 6680
```

### InfluxDB

```toml
[influxdb]
  # Activate the write to influxDB
  # Default : false
  # Format : bool
  enable = false
  # Address of influxDB 
  # Default : ""
  # Format : "http://fqdn:port" 
  addr = "http://influxdb:8086"
  # InfluxDB user 
  # Default : ""
  # Format : string
  user = "user"
  # InfluxDB user password 
  # Default : ""
  # Format : string
  password = "user"
  # InfluxDB database 
  # Default : ""
  # Format : string
  database = "vigie"
```

### Alerting

```toml
[alerting]
  # Activate the built-in alerting of Vigie
  # Default : false
  # Format : bool
  enable = true
  # Interval at wich new errors are evaluted and trigger a notification (if any changes)
  # Default : "10s"
  # Format : duration string from rfc3339
  interval = "3s"
  # Reminder is an interval that necessarily triggers a notification describing the current state of the X Vigie state.
  # (Endorse also the function of DeadMenSwitch)
  # Default : "4h"
  # Format : duration string from rfc3339
  reminder = "4h"
  [alerting.email]
    # Recipient ot the alert
    # Default : ""
    # Format : "name@domain.tld"
    to = ""
    # Emitter of the alert
    # Default : ""
    # Format: "name@domain.tld"
    from = ""
    # SMTP username
    # Default : ""
    # Format: "string"
    username = ""
    # SMTP password
    # Default : ""
    # Format: "string"
    password = ""
    # SMTP fqdn
    # Default : ""
    # Format: "string"
    smtp  = ""
    # SMTP port
    # Default : 0
    # Format: int
    port = 25
  [alerting.discord]
    # Discord webhook
    # Default : ""
    # Format: "https://discordapp.com/api/webhooks/000000000000000/aaaaaazzzzzzz"
    webhook = ""
  [alerting.slack]
    # Slack webhook
    # Default : ""
    # Format: "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
    webhook = ""
    # Slack channel (optional) Overload the channel defined when creating the webhook.
    # Default : ""
    # Format: string
    channel = ""

```
