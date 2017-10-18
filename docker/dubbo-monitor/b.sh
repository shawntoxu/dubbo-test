
image_name=dubbo-monitor:test

#docker build -t xxx:5000/ec-network/${image_name} ./

#docker kill test-monitor && docker rm test-monitor
docker ps -a  | grep Exited  | awk '{print $1}' | xargs docker rm 

docker run -d --name test-monitor -e "ZK_ADDRESS=172.30.10.122:42185" -e "DUBBO_GROUP=TEST_GROUP" -p 9090:8080 xxx:5000/${image_name} 

docker exec -it test-monitor /bin/bash 
 
