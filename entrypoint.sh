export CONTAINER_IP=$(hostname -i)
echo "ip: $CONTAINER_IP , name will be: phoenix@$CONTAINER_IP"
export RELEASE_DISTRIBUTION=name
export RELEASE_NODE="phoenix@${CONTAINER_IP}"
export CONNECT_TO_SERVER=true
# You can use
# ./bin/standard eval MyModule.migrate()
# to execute one off function such as migrations at container boot
./bin/standard start