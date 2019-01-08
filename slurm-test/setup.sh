# Changes to the original setup
git clone https://github.com/giovtorres/docker-centos7-slurm
cat docker-compose.yml > docker-centos7-slurm/docker-compose.yml

cat Dockerfile > docker-centos7-slurm/Dockerfile
cat docker-entrypoint.sh > docker-centos7-slurm/docker-entrypoint.sh

mv json_parser.py docker-centos7-slurm/json_parser.py
mv selector.py docker-centos7-slurm/selector.py

cd docker-centos7-slurm

# Needed environmental variables
printf "Enter Conductor IP (without http://): "
read CONDUCTOR_IP
printf "Enter conductor password: "
read CONDUCTOR_PASSWORD
printf "Enter output data path: "
read ODP

CONDUCTOR_IP="$CONDUCTOR_IP"  CONDUCTOR_PASSWORD="$CONDUCTOR_PASSWORD" ODP="$ODP" docker-compose up -d --build
cd ..
