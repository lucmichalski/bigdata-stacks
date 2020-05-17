
## DataSet 

### PLUTO and MapPLUTO

Download and Extract to ```/data``` Directory

```
https://www1.nyc.gov/site/planning/data-maps/open-data/dwn-pluto-mappluto.page
```


### Load Data 


Make Directory

```
curl -i -X PUT "http://192.168.99.100:9870/webhdfs/v1/pluto?user.name=root&op=MKDIRS"
```

#### Create File
```
curl -i -X PUT "http://192.168.99.100:9870/webhdfs/v1/pluto/pluto_20v1.csv?user.name=root&op=CREATE"
```

![](../assets/redirect.png)

#### Submit File

```
curl -i -X PUT -T pluto_20v1.csv "http://192.168.99.100:9864/webhdfs/v1/pluto/pluto_20v1.csv?op=CREATE&user.name=root&namenoderpcaddress=namenode:9000&createflag=&createparent=true&overwrite=false"
```
View File in Directory Browser

![](../assets/filesystem.png)
