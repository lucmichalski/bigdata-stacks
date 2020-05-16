Write-Host -ForegroundColor Yellow "Starting Redis..."
docker-compose up --detach

Write-Host -ForegroundColor Yellow "Opening rebrow (for visual representation)"
[Diagnostics.Process]::Start('http://localhost:8087')

Write-Host -ForegroundColor Yellow "Connecting to the CLI..."
docker exec -it 7dbs_redis_db redis-cli