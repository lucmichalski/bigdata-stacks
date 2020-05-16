docker-compose -f cluster\mongo-cluster-docker\docker-compose.1.yml -f cluster\mongo-cluster-docker\docker-compose.2.yml  -f cluster\mongo-cluster-docker\docker-compose.cnf.yml -f cluster\mongo-cluster-docker\docker-compose.shard.yml -f cluster\docker-compose.gui.yml up --detach

# No authentication needed
Write-Host -ForegroundColor Yellow "Connecting to the CLI..."
Start-Sleep -Seconds 3
docker exec -it mongo-router mongo