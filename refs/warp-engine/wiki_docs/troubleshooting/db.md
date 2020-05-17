# databases

## Private DB Registry

```bash
ERROR: pull access denied for 123456789.dkr.ecr.us-east-1.amazonaws.com/sample-site-dbs, 
repository does not exist or may require‘docker login’: denied: Your Authorization Token has expired. 
Please run ‘aws ecr get-login --no-include-email’ to fetch a new one.
```

### possible solutions
- login to aws by console

-------------

## Update DB

After update images with de following command `warp update --images`, you dont see changes on db

```bash
Error response from daemon: remove example-volume-db: 
volume is in use - [4dde9b2e67f76760f8531adkjaskldjaklsdjkla 962e735f8d878df24a4fb, 26b101b5cffb70de9asdññlm324sl234506786b1cdc43015a2d799dee08]
```

### possible solutions

```bash
warp stop --hard
warp volume --rm mysql
warp start
```

-------------
