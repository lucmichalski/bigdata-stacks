# Warp10 distributed mode

## Tokens
```json
{
    "read": {
        "token": "EkzBBTTuZ0sS.uM6JA7zzftpEswLzGqsKDUKCCIYVGZfM.dlDOun_lLNYIdBsh4PCRudkrXaNRCVvXeK9XuyQ45pD6QJdvJjyyJpW39jSs4BTLtIy79NjV",
        "tokenIdent": "f170a114af5d917c",
        "ttl": 31536000000,
        "application": "myApp",
        "applications": [
            "myApp"
        ],
        "owners": [
            "2cd83079-1e22-4764-8665-884a9baef606"
        ],
        "producer": "2cd83079-1e22-4764-8665-884a9baef606",
        "producers": []
    },
    "write": {
        "token": "1IvXdDQdhH00zmuGIWyzG4HGPWSxdQcjHGWzJmueRc135c1OudcPfiXozrfP9dMJh8uaerlVczLgOwlNw5MnOKRhk3WyN6i4W.rXsDHNobJ",
        "tokenIdent": "87984be47a40405b",
        "ttl": 31536000000,
        "application": "myApp",
        "owner": "2cd83079-1e22-4764-8665-884a9baef606",
        "producer": "2cd83079-1e22-4764-8665-884a9baef606"
    }
}
```

## curl

```shell
curl -v -H 'X-Warp10-Token: 1IvXdDQdhH00zmuGIWyzG4HGPWSxdQcjHGWzJmueRc135c1OudcPfiXozrfP9dMJh8uaerlVczLgOwlNw5MnOKRhk3WyN6i4W.rXsDHNobJ' --data-binary "// test{} 42" 'http://127.0.0.1:8080/api/v0/update'

curl --data-binary "[ 'EkzBBTTuZ0sS.uM6JA7zzftpEswLzGqsKDUKCCIYVGZfM.dlDOun_lLNYIdBsh4PCRudkrXaNRCVvXeK9XuyQ45pD6QJdvJjyyJpW39jSs4BTLtIy79NjV' 'test' {} NOW -99 ] FETCH" 'http://127.0.0.1:8081/api/v0/exec'
```

## HBase shell

```shell
docker exec -ti hbase /bin/bash
root@ea95b020a1ca:/opt/hbase# ./bin/hbase shell
# ...
hbase(main):001:0> scan 'continuum'
# rows starting with M are metadatas (i.e directory is working)
```