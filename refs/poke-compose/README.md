# poke-compose
A docker compose to test Poke's stack

# How-to

```sh
docker-compose --project-name poke up
```

## Add your own aggregation scripts

The folder `warpscripts` is mounted on the right container. Meaning that you can add warpscripts to this folder and they will be runned through Warp10 Runner.