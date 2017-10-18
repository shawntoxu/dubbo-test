
image_name=pro:test

docker build -t xxx:5000/shawn/${image_name} ./

docker kill test-image-1 && docker rm test-image-1
docker ps -a  | grep Exited  | awk '{print $1}' | xargs docker rm 

docker run -d --name test-image-1 -e "ZK_ADDRESS=172.30.10.122:42185" -p 9200:9200  xxx:5000/shawn/${image_name} 

docker exec -it test-image-1 /bin/bash 
 
