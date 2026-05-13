# Set the 'll' alias for 'ls -alF'
alias ll='ls -alF'
# Set aliases for Kafka commands with common parameters
# Adjust BOOTSTRAP_SERVERS, CLIENT_PROPERTIES, and SCHEMA_REGISTRY as needed
# Example:
# export BOOTSTRAP_SERVERS='localhost:9092'
# export CLIENT_PROPERTIES='/path/to/client.properties'
# export SCHEMA_REGISTRY='http://localhost:8081'
alias kt='kafka-topics --bootstrap-server $BOOTSTRAP_SERVERS --command-config $CLIENT_PROPERTIES'
alias kc='kafka-console-consumer --bootstrap-server $BOOTSTRAP_SERVERS --consumer.config $CLIENT_PROPERTIES'
alias kp='kafka-console-producer --bootstrap-server $BOOTSTRAP_SERVERS --producer.config $CLIENT_PROPERTIES'
alias kcg='kafka-consumer-groups --bootstrap-server $BOOTSTRAP_SERVERS --command-config $CLIENT_PROPERTIES'
alias kac='kafka-avro-console-consumer --bootstrap-server $BOOTSTRAP_SERVERS --consumer.config $CLIENT_PROPERTIES --property schema.registry.url=$SCHEMA_REGISTRY'
alias kap='kafka-avro-console-producer --bootstrap-server $BOOTSTRAP_SERVERS --producer.config $CLIENT_PROPERTIES --property schema.registry.url=$SCHEMA_REGISTRY'
