# Docker Compose File for Building NoSQL Environments

A  simple NoSQL demo building upon Docker and Docker Compose for  the graduate course "Software Ecosystem of Big Data".

## 0. Operating Environment

Docker Version: 18.09.0 
- [Windows: https://docs.docker.com/toolbox/toolbox_install_windows/](https://docs.docker.com/toolbox/toolbox_install_windows/) 
- [Linux: https://docs.docker.com/install/linux/docker-ce/ubuntu/](https://docs.docker.com/install/linux/docker-ce/ubuntu)

Docker Compose Version: 1.23.1 
- pre-installed in `Docker Toolbox for Windows` 
- [Linux: https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

**Note:** enough memory is required for running the HBase stack!!! Check your machine provision, or modify your virtual machine configuration.

## 1. Start
``` 
docker-compose -f docker-compose.yml up -d
```

## 2. Redis
```
docker exec -it redis /bin/bash -c redis-cli

# Or use the command to avoid problems while using "git for windows"
docker exec -it redis //bin/bash -c redis-cli
```

## 3. MongoDB
```
docker exec -it mongo /bin/bash -c mongo

# Or use the command to avoid problems while using "git for windows"
docker exec -it mongo //bin/bash -c mongo
```

## 4. Cassandra
```
docker exec -it cassandra /bin/bash -c cqlsh

# Or use the command to avoid problems while using "git for windows"
docker exec -it cassandra //bin/bash -c cqlsh
```

## 5. HBase
```
# The HBase stack is from https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=70256303.
# Or, you can refer to  another HBase stack  https://github.com/big-data-europe/docker-hbase.
docker exec -it hbase /bin/bash -c 'hbase shell'

# Or use the command to avoid problems while using "git for windows"
docker exec -it hbase //bin/bash -c 'hbase shell'
```

## 6. Neo4j
```
docker exec -it neo4j /bin/bash -c 'cypher-shell -u neo4j -p neo4j'

# or if NEO4J_AUTH=none is set, then
docker exec -it neo4j /bin/bash -c cypher-shell

# Or use the command to avoid problems while using "git for windows"
docker exec -it neo4j //bin/bash -c cypher-shell

# You can also browse to http://localhost:7474 or http://host-ip:7474, and remember to modify the bolt address.
```

## 7. End
```
docker-compose -f docker-compose.yml down

# Or use the commands bellow:
docker-compose -f docker-compose.yml stop
docker-compose rm
```

## Appendix: Operation Records
### Redis:
1. String
```
set name "big data"
get name
exists name
del name
```

2.Hashes
```
hmset big_data_book name "big data" published 2018
hgetall big_data_book
hget big_data_book name
del big_data_book
```

3.List
```
lpush big_data_book chapter_1
lpush big_data_book chapter_2
lpush big_data_book chapter_2
lpush big_data_book chapter_3
lpush big_data_book chapter_4
lrange big_data_book 0 3
lpop big_data_book
del big_data_book
```

4. Sets
```
sadd big_data_book chapter_1
sadd big_data_book chapter_2
sadd big_data_book chapter_2
sadd big_data_book chapter_3
sadd big_data_book chapter_4
smembers big_data_book
scard big_data_book
del big_data_book
```

5. Sorted Sets
```
zadd big_data_book 10 chapter_1
zadd big_data_book 5 chapter_2
zadd big_data_book 6 chapter_3
zadd big_data_book 8 chapter_4
zrange big_data_book 0 3 withscores
zcard big_data_book
del big_data_book
```

6. Bitmap
```
setbit bit_sets 7 1
get bit_sets
getbit bit_sets 7
```

7. HyperLogLog
```
pfadd data 1
pfadd data 2
pfadd data 3
pfadd data 7
pfadd data 10
pfadd data 2
pfadd data 8
pfcount data
```

8. Publish/Subscribe(e.g. a short dialogue)
```
# a.
subscribe chatroom
publish chatroom "Is there anybody?"
publish chatroom "Nobody? Okay, maybe I should try another."

# b.
subscribe chatroom
publish chatroom "Nobody!"
```

### MongoDB
```
use xjtu;
db.students.insert({"firstName":"SAN","lastName":"ZHANG", "hometown":"HENAN", "born":1991});
db.students.insert({"firstName":"SI","lastName":"LI", "hometown":"SHANXI", "born":1992});
db.students.find()
db.students.find({"lastName":"ZHANG"})
db.students.find({"born":{$gt:2000}})
db.students.find({"born":{$gt:1990}})
db.students.update({"firstName":"SAN","lastName":"ZHANG"},{$set:{"born":1995}})
db.students.find()
db.students.remove({"firstName":"SAN","lastName":"ZHANG"})
db.students.find()
db.students.count()
```

### Cassandra
```
CREATE KEYSPACE books WITH REPLICATION={'class':'SimpleStrategy','replication_factor':3};

USE books;

DESCRIBE COLUMNFAMILIES;

CREATE TABLE authors(
  name text,
  gender text,
  born int,
  died int,
  bio text,
  genre set<text>,
  PRIMARY KEY (name));

ALTER TABLE authors ADD picture blob;
ALTER TABLE authors DROP gender;
# DROP TABLE authors;

INSERT INTO authors(name)
VALUES ('XIAOHONG');

SELECT * FROM authors LIMIT 10;

UPDATE authors SET born = 1992
WHERE name='XIAOMING';

SELECT * FROM authors
where NAME= 'XIAOMING';

UPDATE authors SET genre = genre +{'Math'} where name='XIAOMING';

DELETE FROM authors
WHERE name='XIAOHONG';

CREATE TABLE books(
  author text,
  born int static,
  title text,
  published int,
  PRIMARY KEY ((author),title)
);

INSERT INTO books(author,title) VALUES('XIAOMING','1+1');
SELECT * FROM books WHERE author='XIAOMING';

UPDATE books SET born=1992 WHERE author='XIAOMING';
SELECT * FROM books WHERE author='XIAOMING';

INSERT INTO books(author,title,published) VALUES ('XIAOMING','Computer Science 101', 2017);
SELECT * FROM books WHERE author='XIAOMING';
```

### HBase
```
# Refer to: http://www.kaifaxueyuan.com/database/hbase/hbase-create-table.html

create 'emp', 'personal data', 'professional data'
list

put 'emp','1','personal data:name','raju'
put 'emp','1','personal data:city','hyderabad'
put 'emp','1','professional data:designation','manager'
put 'emp','1','professional data:salary','50000'

put 'emp','2','personal data:name','ravi'
put 'emp','2','personal data:city','chennai'
put 'emp','2','professional data:designation','sr.engineer'
put 'emp','2','professional data:salary','30000'

put 'emp','3','personal data:name','rajesh'
put 'emp','3','personal data:city','delhi'
put 'emp','3','professional data:designation','jr.engineer'
put 'emp','3','professional data:salary','25000'

scan 'emp'

put 'emp','1','personal data:city','Delhi'
scan 'emp'

get 'emp', '1'
get 'emp', '1', {COLUMN=>'personal data:name'}

delete 'emp', '1', 'personal data:city',1417521848375
deleteall 'emp','1'
scan 'emp'

disable 'emp'
drop 'emp'
```

### Neo4J
```
CREATE (sample) 
MATCH (n) RETURN n 
CREATE (node1),(node2)
MATCH (n) RETURN n

CREATE (ZHANGSAN:Teacher{name: "ZHANG San"}) 
CREATE (LISI:Person:Student{name: "LI Si"}) 
CREATE (WANGWU:Student{name: "WANG Wu", born: 1993, major:"CS"})  RETURN WANGWU

CREATE (CHENLIU:Student{name: "CHEN Liu", born: 1992, major:"MATH"})
MATCH (node:Student {name: "CHEN Liu"}) 
DETACH DELETE node

MATCH (a:Teacher), (b:Student) 
   WHERE a.name = "ZHANG San" AND b.name = "LI Si" 
CREATE (a)-[:teaches]->(b) 
RETURN a,b 

MATCH (a:Teacher), (b:Student) 
   WHERE a.name = "ZHANG San" AND b.name = "WANG Wu" 
CREATE (a)-[:teaches]->(b) 
RETURN a,b 

MATCH (n) RETURN n

match(n)
optional match(n)-[r]-()
delete n,r
```