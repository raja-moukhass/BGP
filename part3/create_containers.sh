### Creat Host_wil ###
docker pull alpine
docker run -d alpine 
host_wil=$(docker ps -a | grep alpine | awk 'NF{ print $NF }')
echo $host_wil
docker stop $host_wil

docker commit $host_wil host_ramoukha_1
docker commit $host_wil host_ramoukha_2
docker commit $host_wil host_ramoukha_3


### Creat Routeur_wil ###
docker pull frrouting/frr
docker run -d frrouting/frr
routeur_wil=$(docker ps -a | grep frrouting/frr | awk 'NF{ print $NF }')
echo $routeur_wil
### SCRIT HERE

#RWN=$(docker ps -a | grep  frrouting | awk 'NF{ print $NF }')
CREATED=$(docker ps -f "status=created" | grep routeur_wil | wc -l)
SCRIPT=$(docker exec -it $routeur_wil sh -c "sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
sed -i 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons
sed -i 's/isisd=no/isisd=yes/g' /etc/frr/daemons")

if (($CREATED > 0))
then
$SCRIPT
echo "CREATED"
else
docker start $routeur_wil
echo "EXITED"
$SCRIPT
echo "NOW .. CREATED"
fi

docker stop $routeur_wil

docker commit $routeur_wil router_ramoukha_1
docker commit $routeur_wil router_ramoukha_2
docker commit $routeur_wil router_ramoukha_3
docker commit $routeur_wil router_ramoukha_4

