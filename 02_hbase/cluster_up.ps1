Write-Host -ForegroundColor Yellow "Starting HBase (local cluster)..."
docker-compose -f docker-images\docker-compose-distributed-local.yml up --detach

# Write-Host -ForegroundColor Yellow "Opening adminer (for visual representation)"
[Diagnostics.Process]::Start('http://localhost:16010')

# Connect to HBase shell
Write-Host -ForegroundColor Yellow "To connect to the shell: /opt/hbase-1.2.6/bin/hbase shell"
Write-Host -ForegroundColor Yellow "To access scripts: /tmp/scripts/"
docker exec -it hbase-master /bin/bash