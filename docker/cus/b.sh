
image_name=cus:test

docker build -t xxx:5000/shawn/${image_name} ./

docker kill test-image && docker rm test-image
docker ps -a  | grep Exited  | awk '{print $1}' | xargs docker rm 

docker run -d --name test-image -e "ZK_ADDRESS=172.30.10.122:42185" -p 8080:8080 xxx:5000/shawn/${image_name} 

docker exec -it test-image /bin/bash 
 
