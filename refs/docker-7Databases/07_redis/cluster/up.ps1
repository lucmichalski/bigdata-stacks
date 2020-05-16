Write-Host -ForegroundColor Yellow "Starting Redis Cluster..."
docker network create -d bridge --subnet 173.17.0.0/24 redis_net
docker-compose up --detach

Write-Host -ForegroundColor Yellow "Attempting to Cluster Redis instances..."
docker-compose -f docker-compose-cluster.yml up

Write-Host -ForegroundColor Yellow "Opening rebrow (for visual representation)"
[Diagnostics.Process]::Start('http://localhost:8097')

Write-Host -ForegroundColor Yellow "Connecting to the CLI..."
# docker exec -it 7dbs_redis_db redis-cli