#!/usr/bin/env bash

./generate_endpoints.sh

while [[ true ]]
do
    for i in $(seq 1 $NUM_TOPICS)
    do
        bin/kafka-topics.sh --describe --bootstrap-server ${BOOTSTRAP_SERVERS} --topic "test-topic-${i}" 
        if [ $? -eq 1 ];then
            bin/kafka-topics.sh --create --bootstrap-server ${BOOTSTRAP_SERVERS} --topic "test-topic-${i}"  --partitions 3 --replication-factor 2
        fi 
        bin/kafka-producer-perf-test.sh --producer.config config/producer.properties --print-metrics --throughput ${PRODUCER_THROUGHPUT} --num-records ${NUM_RECORDS} --topic "test-topic-${i}" --record-size ${RECORD_SIZE}
        sleep ${TEST_INTERVAL_SECONDS}
    done
done
