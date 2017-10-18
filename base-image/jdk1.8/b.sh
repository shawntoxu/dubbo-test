docker build -t xxx:5000/jdk:1.8.0_131 ./


docker kill test-image && docker rm test-image
docker ps -a  | grep Exited  | awk '{print $1}' | xargs docker rm 

docker run -d --name test-image xxx:5000/jdk:1.8.0_131 


docker exec -it test-image /bin/bash 
 
