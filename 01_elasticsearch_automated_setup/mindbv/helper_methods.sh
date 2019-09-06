

# --------------------------------------------- DELETE INDEX REQUEST ------------------------------------------------
curl -X DELETE "178.128.139.27:9200/inserats?pretty"
# ------------------------------------------- END DELETE INDEX REQUEST ----------------------------------------------




# ------------------------------------------------- CACHING ADJUSTMENT ----------------------------------------------
# Enable / Disable Caching
# according to documentation:
#   - https://www.elastic.co/guide/en/elasticsearch/reference/current/shard-request-cache.html
#   - https://www.elastic.co/guide/en/elasticsearch/reference/current/query-cache.html
#..................................................................................................................
# UPDATE INDEX - DISABLE CACHING
curl -X PUT "206.189.99.201:9200/inserats1/_settings?pretty" -H 'Content-Type: application/json' -d'
{
	"index" : {
		"requests.cache.enable": false
	}
}'

# UPDATE INDEX - ENABLE CACHING
curl -X PUT "206.189.99.201:9200/inserats1/_settings?pretty" -H 'Content-Type: application/json' -d'
{
	"index" : {
		"requests.cache.enable": false
	}
}'
# ---------------------------------------------- END CACHING ADJUSTMENT -------------------------------------------






# ---------------------------------------------- MOVE SHARD TO OTHER NODE -----------------------------------------
curl -X POST "206.189.99.201:9200/_cluster/reroute?pretty" -H 'Content-Type: application/json' -d'
{
	"commands" : [
		{
			"move" : {
				"index" : "inserats1", "shard" : 3,
				"from_node" : "master1", "to_node" : "data1"
			}
		}
	]
}'
# -------------------------------------------- END MOVE SHARD TO OTHER NODE ---------------------------------------






# ------------------------------------------------- NODE STATS ----------------------------------------------
curl 206.189.99.201:9200/_nodes/data1/stats?pretty=true
curl 206.189.99.201:9200/_nodes/stats?pretty=true


# -https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-shards.html
curl 206.189.99.201:9200/_cat/shards/inserats?pretty=true
curl -X GET "206.189.99.201:9200/_cat/shards?pretty"
# TOTAL DOCUMENT COUNT
curl 206.189.99.201:9200/inserats/_count?pretty=true
# ------------------------------------------------- END NODE STATS ----------------------------------------------


