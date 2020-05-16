mkdir couch1data
mkdir couch2data
mkdir couch3data

docker build  --file couch-cookie\Dockerfile --tag couch_cluster:latest couch-cookie
docker-compose up -d

Start-Sleep -Seconds 15
.\setup_clustering.ps1
