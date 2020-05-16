Write-Host -ForegroundColor Yellow "Starting Neo4j..."
New-Item -ItemType Directory -Force -Path "data"
New-Item -ItemType Directory -Force -Path "logs"
docker-compose up --detach

Write-Host -ForegroundColor Yellow "Opening GUI)"
[Diagnostics.Process]::Start('http://localhost:8085')
