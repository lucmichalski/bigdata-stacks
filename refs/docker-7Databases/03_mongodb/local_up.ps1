Write-Host -ForegroundColor Yellow "Starting MongoDB..."
docker-compose up --detach

Write-Host -ForegroundColor Yellow "Opening GUI (mongo-express)"
[Diagnostics.Process]::Start('http://localhost:8083')

Write-Host -ForegroundColor Yellow "Connecting to the CLI..."
Start-Sleep -Seconds 3
Write-Host -ForegroundColor Yellow "Username: mongo; Password: gonmo"
docker exec -it 7dbs_mongo_db mongo --username mongo --password gonmo