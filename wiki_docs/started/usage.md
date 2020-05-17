# How to use flag **--help**?

!!! important
    each command has a `--help` option.

**example:**

If you run the following command:

```bash
warp mysql --help
```

You can see detailed help for each command

```bash
Usage:
 warp mysql command [options] [arguments]


Options:

 -h, --help         display this help message

Available commands:
 info               display info available
 dump               allows to make a database dump
 connect            connect to mysql command line (shell)
 import             allows to restore a database
 ssh                connect to mysql by ssh

Help:
 warp mysql dump --help
```

And each sub-command has a `--help` option.

**example:**

```bash
warp mysql dump --help
```


```bash
Usage:
 warp mysql dump [db_name] > [file]


Help:
 Create a backup of a database and save it local machine
 to remove all the security definers of a mysql dump, add this to the command: sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/'

Example:
 warp mysql dump warp_db | gzip > /path/to/save/backup/warp_db.sql.gz
 warp mysql dump warp_db | sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' | gzip > /path/to/save/backup/warp_db.sql.gz
 warp mysql dump warp_db | gzip | pv > /path/to/save/backup/warp_db.sql.gz
 warp mysql dump warp_db > /path/to/save/backup/warp_db.sql
```

**the same option for:**

```bash
warp mysql info --help
```

```bash
warp mysql connect --help
```

```bash
warp mysql import --help
```

```bash
warp mysql ssh --help
```
