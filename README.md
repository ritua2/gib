# ipt

1. Make sure to create a external volume myvol <b>docker volume create --name=myvol</b>
2. Use <b>docker run --rm -it -v $(pwd):/project -w /project maven mvn package</b> to compile the target
3. Execute <b>docker-compose up</b>
