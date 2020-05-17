#!/bin/bash        
if [ ! -d "/opt/warp10/leveldb/LOCK" ]; then
    echo "Creating LevelDB..."
    java -cp /opt/warp10/bin/warp10-1.2.19.jar io.warp10.standalone.WarpInit /opt/warp10/leveldb
fi

echo "starting Warp10..."

java -cp /opt/warp10/bin/warp10-1.2.19.jar io.warp10.standalone.Warp /opt/warp10/etc/conf-standalone.conf