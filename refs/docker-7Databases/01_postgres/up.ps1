Write-Host -ForegroundColor Yellow "Starting PostgreSQL..."
docker-compose up --detach

Write-Host -ForegroundColor Yellow "Opening adminer (for visual representation)"
[Diagnostics.Process]::Start('http://localhost:8081')

Write-Host -ForegroundColor Yellow "Connecting to the CLI..."
docker exec -it 7dbs_postgres_db psql -U postgres -W