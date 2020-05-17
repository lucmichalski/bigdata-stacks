compose:
	docker-compose up --build

images:
	docker build -f Dockerfile.warp -t warp-poke/warp10-distributed-docker:1.3.13 .
	docker build -f Dockerfile.sozu -t warp-poke/warp10-sozu .

clean:
	docker-compose down

test-push-datapoints:
	curl -v -H 'X-Warp10-Token: 1IvXdDQdhH00zmuGIWyzG4HGPWSxdQcjHGWzJmueRc135c1OudcPfiXozrfP9dMJh8uaerlVczLgOwlNw5MnOKRhk3WyN6i4W.rXsDHNobJ' --data-binary "// test{} 42" 'http://127.0.0.1:8080/api/v0/update'
	sleep 1
	curl --data-binary "[ 'EkzBBTTuZ0sS.uM6JA7zzftpEswLzGqsKDUKCCIYVGZfM.dlDOun_lLNYIdBsh4PCRudkrXaNRCVvXeK9XuyQ45pD6QJdvJjyyJpW39jSs4BTLtIy79NjV' 'test' {} NOW -99 ] FETCH" 'http://127.0.0.1:8081/api/v0/exec'