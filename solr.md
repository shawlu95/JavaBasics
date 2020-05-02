### Compared to ES
* built on a Java library called Lucene.
* accept data: XML files, comma-separated value (CSV) files, Word, PDF
* great for full-text search, geolocation/spatial search
* depend on zookeeper (define in `solr.in.sh/solr.in.cmd`)
* Tutorial for [8.5.0](https://lucene.apache.org/solr/guide/8_5/solr-tutorial.html)
* Localhost: `http://localhost:8983/solr`
* [tutorial](https://lucene.apache.org/solr/guide/8_5/solr-tutorial.html)

```bash
# start first node
./bin/solr start -c -p 8983 -s example/cloud/node1/solr

# start second node
./bin/solr start -c -p 7574 -s example/cloud/node2/solr -z localhost:9983

# create a collection
bin/solr create -c films -s 2 -rf 2
bin/solr create -c <yourCollection> -s 2 -rf 2

# delete collection
bin/solr delete -c techproducts
bin/solr delete -c films

# stop solr server
bin/solr stop -all

# reset both nodes
bin/solr stop -all ; rm -Rf example/cloud/
```

### [Indexing](https://lucene.apache.org/solr/guide/8_5/overview-of-documents-fields-and-schema-design.html#overview-of-documents-fields-and-schema-design)
* index a directory of files: `./bin/post -c <collection> <dir_path>`
* [DataImportHandler](https://lucene.apache.org/solr/guide/8_5/uploading-structured-data-store-data-with-the-data-import-handler.html#uploading-structured-data-store-data-with-the-data-import-handler)
* **SolrJ** for JVM-based languages or other Solr clients to programmatically create documents to send to Solr.
* a file named either `managed-schema`(schema API only) or `schema.xml`(manual edit)
  - specify a unique key field `id`, reindexing same input will not cause duplicate
* a collection contains *documents*. Document contains *field*
* specify field type in schema

### Querying
```bash
# search for a single term
curl "http://localhost:8983/solr/techproducts/select?q=foundation"

# field searcb
# look for doc with "electronics" in "cat" field
curl "http://localhost:8983/solr/techproducts/select?q=cat:electronics"

# use double quote for multi-term phrase search
curl "http://localhost:8983/solr/techproducts/select?q=\"CAS+latency\""

# use + to require presence of terms
curl "http://localhost:8983/solr/techproducts/select?q=%2Belectronics%20%2Bmusic"

# use - to ban a term
curl "http://localhost:8983/solr/techproducts/select?q=%2Belectronics+-music"
```

#### Schema
```bash
# define schema
curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"name", "type":"text_general", "multiValued":false, "stored":true}}' http://localhost:8983/solr/films/schema

# add catch-all field
curl -X POST -H 'Content-type:application/json' --data-binary '{"add-copy-field" : {"source":"*","dest":"_text_"}}' http://localhost:8983/solr/films/schema

# index file
bin/post -c films example/films/films.json
bin/post -c films example/films/films.xml
bin/post -c films example/films/films.csv -params "f.genre.split=true&f.directed_by.split=true&f.genre.separator=|&f.directed_by.separator=|"
```

### [Facet](https://lucene.apache.org/solr/guide/8_5/faceting.html#faceting)
```bash
# facet: count number of films in each genre
curl "http://localhost:8983/solr/films/select?q=*:*&rows=0&facet=true&facet.field=genre_str"

# having count(*) >= 200
curl "http://localhost:8983/solr/films/select?=&q=*:*&facet.field=genre_str&facet.mincount=200&facet=on&rows=0"

# date range facet
curl 'http://localhost:8983/solr/films/select?q=*:*&rows=0'\
    '&facet=true'\
    '&facet.range=initial_release_date'\
    '&facet.range.start=NOW-5YEAR'\
    '&facet.range.end=NOW'\
    '&facet.range.gap=%2B1YEAR'

# pivot facet (group by genre and director)
curl "http://localhost:8983/solr/films/select?q=*:*&rows=0&facet=on&facet.pivot=genre_str,directed_by_str"
```

### Deleting
```bash
# Execute the following command to delete a specific document:
bin/post -c localDocs -d "<delete><id>SP2514N</id></delete>"

# To delete all documents, you can use "delete-by-query" command like:
bin/post -c localDocs -d "<delete><query>*:*</query></delete>"
```
