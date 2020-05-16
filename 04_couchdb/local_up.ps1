Write-Host -ForegroundColor Yellow "Starting CouchDB..."
docker-compose up --detach

Write-Host -ForegroundColor Yellow "Opening GUI (Fauxton)"
[Diagnostics.Process]::Start('http://localhost:8084/_utils/#login')
