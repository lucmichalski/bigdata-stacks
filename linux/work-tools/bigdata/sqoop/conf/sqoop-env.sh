# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# included in all the hadoop scripts with source command
# should not be executable directly
# also should not be passed any arguments, since we need original $*

# Set Hadoop-specific environment variables here.

BIGDATA_HOME=/home/alanding/software/bigdata

#Set path to where bin/hadoop is available
export HADOOP_COMMON_HOME=$BIGDATA_HOME/hadoop

#Set path to where hadoop-*-core.jar is available
export HADOOP_MAPRED_HOME=$BIGDATA_HOME/hadoop

#set the path to where bin/hbase is available
export HBASE_HOME=$BIGDATA_HOME/hbase

#Set the path to where bin/hive is available
export HIVE_HOME=$BIGDATA_HOME/hive

#Set the path for where zookeper config dir is
export ZOOKEEPER_HOME=$BIGDATA_HOME/zookeeper
export ZOOCFGDIR=$BIGDATA_HOME/zookeeper
