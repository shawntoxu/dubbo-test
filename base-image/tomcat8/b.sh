docker build -t xxx:5000/tomcat:8.5.14 ./


docker kill test-image && docker rm test-image
docker ps -a  | grep Exited  | awk '{print $1}' | xargs docker rm 

docker run -d --name test-image -p 8080:8080 xxx:5000/tomcat:8.5.14 


docker exec -it test-image /bin/bash 
 
