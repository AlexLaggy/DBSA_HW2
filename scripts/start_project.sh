#!/bin/bash

/opt/hadoop-2.10.1/sbin/stop-dfs.sh
/opt/hadoop-2.10.1/sbin/start-dfs.sh

hdfs dfs -rm -r /user/root
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/root
hdfs dfs -mkdir /user/root/input
#hdfs dfs -mkdir /user/root/output
hdfs dfs -mkdir /user/root/mapping

python3 generator_v2.py
hdfs dfs -put news_time.log /user/root/input/
hdfs dfs -put mapping.log /user/root/mapping/

spark-submit --class lab2.SparkApplication \
              --master local \
              --deploy-mode client \
              --executor-memory 1g \
              --name postcount \
              --conf "spark.app.id=SparkApplication" \
              Spark-1.0-SNAPSHOT-jar-with-dependencies.jar \
              hdfs://localhost:9000/user/root/input/ \
              hdfs://localhost:9000/user/root/mapping/ \
              hdfs://localhost:9000/user/root/output

echo -e "\nFINISH.\n\n/opt/hadoop-2.10.1/bin/hdfs dfs -ls output:"

/opt/hadoop-2.10.1/bin/hdfs dfs -ls output

echo -e "\nFIRST 20 string:\n"
/opt/hadoop-2.10.1/bin/hdfs dfs -cat output/part* | head -n 20
