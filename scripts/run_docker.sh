docker rm -f DSBDA_HW2 #; docker rmi custom_centos:latest

docker build --rm -t custom_centos - < Dockerfile
docker run --privileged -d -p 50070:50070 -ti -e container=docker --name=DSBDA_HW2 -v /sys/fs/cgroup:/sys/fs/cgroup  custom_centos /usr/sbin/init

docker cp ./start_project.sh DSBDA_HW2:/project/
docker cp ../target/Spark-1.0-SNAPSHOT-jar-with-dependencies.jar DSBDA_HW2:/project/
docker cp ./generator_v2.py DSBDA_HW2:/project/
docker cp ./mapping.log DSBDA_HW2:/project/

docker exec -it DSBDA_HW2 /opt/hadoop-2.10.1/bin/hdfs namenode -format
docker exec -it DSBDA_HW2 /opt/hadoop-2.10.1/sbin/start-dfs.sh

docker exec -it DSBDA_HW2 /bin/bash
