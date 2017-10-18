
image_name=nginx:1.12.1

docker build -t xxx:5000/${image_name} ./

docker kill test-image && docker rm test-image
docker ps -a  | grep Exited  | awk '{print $1}' | xargs docker rm 

docker run -d --name test-image xxx:5000/${image_name} 

docker exec -it test-image /bin/bash 
 
