### About ES
* built on a Java library called Lucene.
* RESTful search engine
* index ~ database
* index breaks into shards, each shard replicated
* interest is overtaking that of Solr
* Good for JSON documents
* Good for analytical querying, filtering, and grouping
* Accept data: ActiveMQ, AWS SQS, DynamoDB (Amazon NoSQL), FileSystem, Git, JDBC, JMS, Kafka, LDAP, MongoDB, neo4j, RabbitMQ, Redis, Solr, and Twitte
* Elasticsearch has a built-in, ZooKeeper-like component called Zen that uses its own internal coordination mechanism to handle the cluster state.

### CLI API
```bash
# start elastic search
cd elasticsearch-7.6.2/bin
./elasticsearch
./elasticsearch -Epath.data=data2 -Epath.logs=log2
./elasticsearch -Epath.data=data3 -Epath.logs=log3

# check status
curl -X GET 'http://localhost:9200/_cat/health?v'

# index a document to an index (customer)
curl -X PUT "localhost:9200/customer/_doc/1?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "Shaw"
}
'

# retrieve document
curl -X GET "localhost:9200/customer/_doc/1?pretty"

# use batch to minimize network roundtrips
curl -H "Content-Type: application/json" -XPOST "localhost:9200/bank/_bulk?pretty&refresh" --data-binary "@accounts.json"
curl "localhost:9200/_cat/indices?v"

# search endpoint, "hits" return 10 matches
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ]
}
'

# to get hits 10-19
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ],
  "from": 10,
  "size": 10
}
'

# address contains "mill" or "lane"
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": { "match": { "address": "mill lane" } }
}
'

# address contains "mill lane"
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": { "match_phrase": { "address": "mill lane" } }
}
'

# boolean condition can be "must", "should", "must_not"
# results are ranked by relevance score
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": [
        { "match": { "age": "40" } }
      ],
      "must_not": [
        { "match": { "state": "ID" } }
      ],
      "filter": {
        "range": {
          "balance": {
            "gte": 30000,
            "lte": 40000
          }
        }
      }
    }
  }
}
'

# count documents in each state
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "size": 0,
  "aggs": {
    "group_by_state": {
      "terms": {
        "field": "state.keyword"
      }
    }
  }
}
'

# average balance group by state, order by average balance  
curl -X GET "localhost:9200/bank/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "size": 0,
  "aggs": {
    "group_by_state": {
      "terms": {
        "field": "state.keyword",
        "order": {
          "average_balance_ha": "desc"
        }
      },
      "aggs": {
        "average_balance_ha": {
          "avg": {
            "field": "balance"
          }
        },
        "poorest": {
          "min": {
            "field": "balance"
          }
        },
        "richest": {
          "max": {
            "field": "balance"
          }
        }
      }
    }
  }
}
'
```

### Kibana
* [install](https://www.elastic.co/guide/en/elastic-stack-get-started/7.6/get-started-elastic-stack.html#install-kibana)
* configure the path to elasticsearch server in `kibana.yml`
* port [5601](http://localhost:5601)
```bash
# install on mac
curl -L -O https://artifacts.elastic.co/downloads/kibana/kibana-7.6.2-darwin-x86_64.tar.gz
tar xzvf kibana-7.6.2-darwin-x86_64.tar.gz
cd kibana-7.6.2-darwin-x86_64/
./bin/kibana

# served at http://127.0.0.1:5601
```
