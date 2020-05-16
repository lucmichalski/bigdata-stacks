# 7 Databases in 7 Weeks

This repository contains Docker environments to help you work through "Seven Databases in Seven Weeks".
Details on the book are available on [The Pragmatic Programmers](https://pragprog.com/book/rwdata/seven-databases-in-seven-weeks) website.

## Pre-requisites

Test using Docker CE version 19.03.0-rc2.  If using Windows, note that  **Linux Containers must be enabled**.

## Usage

Make sure you get a copy of the submodules:

```shell
git submodule init
git submodule update
```

Starting a database is just a case of going into the relevant folder and running *up.ps1*.  Some databases also have local cluster examples, which are appropriately named.

When you're done, you can run *down.ps1* to teardown the environment.

## Backlog

- [ ] Finish adding all the databases!
- [ ] Add shell scripts for Linux
