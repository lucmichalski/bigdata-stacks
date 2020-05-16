#Credentials

$creds = 'couchdb:bouchdc'
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($creds))
$Headers = @{ Authorization = "Basic $encodedCreds" }

# Local Setup
$json = @{action='enable_cluster'; bind_address='0.0.0.0'; username='couchdb'; password='bouchdc'; node_count='3' } | ConvertTo-Json
Invoke-RestMethod -Method POST -Headers $Headers -ContentType 'application/json' -Uri http://127.0.0.1:15984/_cluster_setup -Body $json

# Couch2
$json = @{action='enable_cluster'; bind_address='0.0.0.0'; username= 'couchdb'; password='bouchdc'; port= 15984; node_count= '3'; remote_node= 'couchdb.two'; remote_current_user= 'couchdb'; remote_current_password= 'bouchdc'} | ConvertTo-Json
Invoke-RestMethod -Method POST -Headers $Headers -ContentType 'application/json' -Uri http://127.0.0.1:15984/_cluster_setup -Body $json
$json = @{action='add_node'; host='couchdb.two'; port='5984'; username='couchdb'; password='bouchdc'} | ConvertTo-Json
Invoke-RestMethod -Method POST -Headers $Headers -ContentType 'application/json' -Uri http://127.0.0.1:15984/_cluster_setup -Body $json

# Couch3
$json = @{action='enable_cluster'; bind_address='0.0.0.0'; username='couchdb'; password='bouchdc'; port='15984'; node_count='3'; remote_node='couchdb.three'; remote_current_user='couchdb'; remote_current_password='bouchdc'} | ConvertTo-Json
Invoke-RestMethod -Method POST -Headers $Headers -ContentType 'application/json' -Uri http://127.0.0.1:15984/_cluster_setup -Body $json
$json = @{action='add_node'; host='couchdb.three'; port= '5984'; username= 'couchdb'; password='bouchdc'} | ConvertTo-Json
Invoke-RestMethod -Method POST -Headers $Headers -ContentType 'application/json' -Uri http://127.0.0.1:15984/_cluster_setup -Body $json

#Finish
$json = @{action='finish_cluster'} | ConvertTo-Json
Invoke-RestMethod -Method POST -Headers $Headers -ContentType 'application/json' -Uri http://127.0.0.1:15984/_cluster_setup -Body $json