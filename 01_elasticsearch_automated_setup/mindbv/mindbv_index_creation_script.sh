# TODOS:
#
# Disk usage guide: 
# 	- Disable the features you do not need
#
# Search speed guide:
# 	- 
#
# Index speed guide:
#	- 
#
# ------------------------------------------- END CREATE INDEX REQUEST ----------------------------------------------























# ---------------------------------------------- CREATE INDEX REQUEST ----------------------------------------------
# CREATE INDEX REQUEST
#
# ALL INDEX OPTIONS
# according to documentation:
#   - https://www.elastic.co/guide/en/elasticsearch/reference/current/index-modules.html
#
#..................................................................................................................

curl -X PUT "10.133.233.129:9200/inserats?pretty" -H 'Content-Type: application/json' -d'
{

	# Keep fields in documents in the same order
	# according to documentation 'Tune for disk usage':
	# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-disk-usage.html#_put_fields_in_the_same_order_in_documents
	# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-disk-usage.html#default-dynamic-string-mapping
	#	- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-disk-usage.html#_use_the_smallest_numeric_type_that_is_sufficient
	# ................................................................................................
	"mappings": {
		"properties": {
			"title":{
				"type": "text"
			},
			"tags": {
				"type": "keyword"
			},
			"total_rent":{
				"type": "short"
			},
			"caution":{
				"type": "short"
			},
			"location": {
				"type": "geo_point"
			},
			"street":{
				"type": "text"
			},
			"city":{
				"type": "text"
			},
			"zip_code":{
				"type": "keyword"
			},
			"inserat_type":{
				"type": "boolean"
			},
			"inserat_provider": {
				"type": "integer"
			}
		}
	},























	# -----------------------------------------------------------------------------------------------------------------------------------------------
	# -----------------------------------------------------------------------------------------------------------------------------------------------
	# -----------------------------------------------------------------------------------------------------------------------------------------------
	# -----------------------------------------------------------------------------------------------------------------------------------------------
	# INDEX SETTINGS
	# according to documentation:
	#   - https://www.elastic.co/guide/en/elasticsearch/reference/current/index-modules.html
	# -----------------------------------------------------------------------------------------------------------------------------------------------
	# -----------------------------------------------------------------------------------------------------------------------------------------------
	# -----------------------------------------------------------------------------------------------------------------------------------------------
	# -----------------------------------------------------------------------------------------------------------------------------------------------
	"settings" : {

		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# INDEX CONTROL SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		# Block settings
		# Control Index
		# ................................................................................................
		"blocks" : {
			"read_only" : "false", 						# make index + index metadata read only
			"read_only_allow_delete" : "false", 		# make index read only, but allow deletes
			"read" : "false", 							# disable read operations for index
			"write" : "false", 							# disable write operations, but allow changes for index metadata
			"metadata" : "false" 						# disable reads and writes on index metadata
		},





		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# GENERAL SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

# Compression
# slows down indexing performance
# improves disk usage
# according to documentation 'Tune for disk usage':
# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-disk-usage.html#best-compression
# ................................................................................................
"index.codec" : "best_compression",				# use DEFLATE for higher compression


		# Delete rules
		# ................................................................................................
		"gc_deletes" : "60s",                			# The length of time that a deleted document’s version number remains available for further versioned operations


		# Ingest Node rules
		# ................................................................................................
		"default_pipeline" : "_none",        			# The default ingest node pipeline for this index


		# Custom routing
		# ................................................................................................
		"routing_partition_size" : "1",     			# number of shards a custom routing value can go to




		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# INDEXING SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		# Indexing
		# Maximal number for requests sent with refresh=wait_for flag.
		# Forces refresh when exceeded
		# according to documentation:
		# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-refresh.html
		# ................................................................................................
		"max_refresh_listeners" : "100",      			# Maximum number of refresh listeners available on each shard / Force Refresh when at least 100 requests are waiting for refresh


		# Percolator type
		# according to documentation:
		# 	- https://www.elastic.co/guide/en/elasticsearch/reference/7.3/percolator.html
		"percolator" : {
			"map_unmapped_fields_as_text" : "false"		# force unmapped fields as strings if 
		},


# Presorting index by rent since used in filtered query
# improves boudary detection for more search speed
# improves compression of documents for better disk usage
# slightly decreases indexing speed
# according to documentation:
#	- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-search-speed.html#_use_index_sorting_to_speed_up_conjunctions
# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-disk-usage.html#_use_index_sorting_to_colocate_similar_documents
# ................................................................................................

"sort" : {
	"missing" : [ ],				# [_last, _first] how to treat documents that are missing the field
	"mode" : [ ],					# [min / max] defines the taken value for multivalue fields
	"field" : ["total_rent"],		# define sort field for index sorting
	"order" : ["asc"]				# define sort order for index sorting
},


# Refresh interval - Interval to make new indexed docs ready for search (slows indexing)
# optimization 1:
# if your index experiences regular search requests increasing the index.refresh_interval to a larger value, e.g. 30s, might help improve indexing speed.
# according to documentation:
# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-indexing-speed.html#_unset_or_increase_the_refresh_interval
#
# optimization 2:
# for indexing large amount of data disable refresh by setting index.refresh_interval to -1 (toggle before and after large index action)
# according to documentation:
#   - https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-indexing-speed.html#_disable_refresh_and_replicas_for_initial_loads
# ................................................................................................
"refresh_interval" : "30s",  # interval to make new indexed docs ready for search (slows indexing)
		
	


		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# QUERY SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		# Windowing
		# Not neccessary cause application limits max values for from + size
		# ................................................................................................
		"max_result_window" : "10000",       # The maximum value of from + size for searches
		"max_inner_result_window" : "100",   # The maximum value of from + size for inner hits definition and top hits aggregations
		"max_rescore_window" : "10000",      # The maximum value of window_size for rescore requests in searches


		# Aggregation Limitations
		# ................................................................................................
		"max_adjacency_matrix_filters" : "100",


		# Ananlyser limitations
		# ................................................................................................
		"max_ngram_diff" : "1",         # The maximum allowed difference between min_gram and max_gram for NGramTokenizer 
		"max_shingle_diff" : "3",       # The maximum allowed difference between max_shingle_size and min_shingle_size for ShingleTokenFilter


		# Query limitations
		# ................................................................................................
		"max_docvalue_fields_search" : "100",      # The maximum number of docvalue_fields that are allowed in a query
		"max_script_fields" : "32",                # The maximum number of script_fields that are allowed in a query
		"max_terms_count" : "65536",               # The maximum number of terms that can be used in Terms Query
		"max_regex_length" : "1000",               # The maximum length of regex that can be used in Regexp Query


		# Search settings
		# ................................................................................................
		"search" : {
			"throttled" : "false"			# slow down search for development
		},

		"query_string" : {
			"lenient" : "false" # format-based errors, such as providing a text value for a numeric field, are ignored
		},


		# Highlighting settings
		# not needed since no highlighting is used
		# ................................................................................................
		"highlight" : {
			"max_analyzed_offset" : "1000000"			# maximum number of characters that will be analyzed for a highlight request
		},




		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# CLUSTER STARTUP & RECOVERY SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		# Cluster startup settings
		# ................................................................................................
		"write" : {
			"wait_for_active_shards" : "1" # at least wait for all primary shards (wait_for_active_shards=2 -> wait for primary and at least one replica)
		},


		# Index Recovery
		# according to documentation:
		#	- https://www.elastic.co/guide/en/elasticsearch/reference/7.3/recovery-prioritization.html
		# ................................................................................................
		"priority" : "1",	# specifies the order indices are recovered in, when multiple indices exists in the cluster


# Eager load nested queries to search for nested fields
# Not needed since no nested fields are used
# ................................................................................................
"load_fixed_bitset_filters_eagerly" : "true", 	# eager load nested queries


		# Lucene Transaction log for transaction recovery in cluster failure cases
		# according to documentation:
		# 	- https://www.elastic.co/guide/en/elasticsearch/reference/7.3/index-modules-translog.html
		# 	- https://github.com/elastic/elasticsearch/blob/v6.2.4/server/src/main/java/org/elasticsearch/index/IndexSettings.java#L210
		# ................................................................................................
		"translog" : {
			"generation_threshold_size" : "64mb",	# The maximum size of a translog generation. This is independent of the maximum size of translog operations that have not been flushed.
			"flush_threshold_size" : "512mb",		# the maximum total size of operations in the translog, to prevent recoveries from taking too long
			"sync_interval" : "5s",					# How often the translog is fsynced to disk and committed for async durability
			"retention" : {
				"size" : "512mb",					# The total size of translog files to keep
				"age" : "12h"						# The maximum duration for which translog files will be kept
			},
			"durability" : "REQUEST" 				# [REQUEST / ASYNC] report success of an index, delete, update, or bulk request to the client after the translog has been successfully fsynced to disc
		},





		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# CACHE SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		# Filesystem storage settings
		# Warm up filesystem cache
		# speed up search speed
		# according to documentation:
		# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-search-speed.html#_warm_up_the_filesystem_cache
		# ................................................................................................
		"store" : {

			"stats_refresh_interval" : "10s",	# update interval for caches store size

			# filesystem type
			# according to documentation:
			# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/index-modules-store.html#file-system
			# ................................................................................................
			"type" : "",


			# filesystem lock
			# according to documentation:
			# 	- https://github.com/elastic/elasticsearch/issues/1535
			# ................................................................................................
			"fs" : {
				"fs_lock" : "native" # [none / native] lock / unlock filesystem cache (not documented well)
			},


# Warm up the filesystem cache
# recommended for tuning for search speed
# according to documentation
# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-search-speed.html
"preload" : ["nvd", "dvd", "dim"]	# preload norms, doc values, and points in filesystemcache at cluster restart
		},





		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# MAPPING SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		# Mapping settings
		# ................................................................................................
		"mapping" : {
			# Coerce
			# clean up dirty values to fit the datatype of a field
			# rescue "10" or 10.0 to integer datatype without indexation failure
			# can be set at mapping configuration
			# ................................................................................................
			"coerce" : "false",		# clean up dirty values to fit the datatype of a field

			# Trivial settings
			# ................................................................................................
			"nested_fields" : {
				"limit" : "50"
			},
			"depth" : {
				"limit" : "20" 
			},
			"field_name_length" : {
				"limit" : "9223372036854775807"
			},
			"total_fields" : {
				"limit" : "1000"
			},
			"nested_objects" : {
				"limit" : "10000"
			},
			"ignore_malformed" : "false" 	# ignore malformated mapping exceptions
		},

		# allow indexing unmapped fields (default true)
		# ................................................................................................
		"query" : {
			"default_field" : [
				"*"
			],
			"parse" : {
				"allow_unmapped_fields" : "false"
			}
		},


		# not documented (allow dynamic mappings according to documentation of ES 1.7)
		# ................................................................................................
		"mapper" : {
			"dynamic" : "true"
		},




		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# API SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		# Splitting Index API
		# Not used at all
		# according to documentation:
		#	- https://www.elastic.co/guide/en/elasticsearch/reference/7.3/indices-split-index.html
		# ................................................................................................
		"number_of_routing_shards" : "1", 		# number of times the index can be split (and the number of shards that each original shard can be split into)


		# Scroll API settings
		# according to documentation:
		#	- https://www.elastic.co/guide/en/elasticsearch/reference/7.3/search-request-body.html#request-body-search-scroll
		# ................................................................................................
		"max_slices_per_scroll" : "1024",	# the maximum number of slices allowed per scroll

		
		# Analyze API settings
		# ................................................................................................
		"analyze" : {
			"max_token_count" : "10000" # maximum number of tokens that can be produced using _analyze API
		},




		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# LOGGING SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		"search" : {
			# Search request logging settings
			# ................................................................................................
			"slowlog" : {
				"level" : "TRACE", 		# loglevel
				"threshold" : {
					"fetch" : {
						"warn" : "10s", # time before a query gets logged as warning in fetch phase
						"trace" : "-1",	# time before a query gets logged as trace in fetch phase
						"debug" : "-1",	# time before a query gets logged as debug in fetch phase
						"info" : "-1"	# time before a query gets logged as info in fetch phase
					},
					"query" : {
						"warn" : "10s", #  time before a query gets logged as warning in query phase
						"trace" : "-1",	#  time before a query gets logged as trace in query phase
						"debug" : "-1",	#  time before a query gets logged as debug in query phase
						"info" : "-1"	#  time before a query gets logged as info in query phase
					}
				}
			}
		},

		"indexing" : {
			"slowlog" : {
				"level" : "TRACE",		# loglevel
				"reformat" : "true",	# not documented
				"source" : "1000",		# not documented
				"threshold" : {
					"index" : {
						"warn" : "10s",	# time before a query gets logged as warning while indexing
						"trace" : "-1",	# time before a query gets logged as trace while indexing
						"debug" : "-1",	# time before a query gets logged as debug while indexing
						"info" : "-1"	# time before a query gets logged as info while indexing
					}
				}
			}
		},
























		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# SHARD RELEVANT SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# QUERY SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		"search": {
			# shards that haven’t seen search traffic for at least index.search.idle.after seconds 
			# will not receive background refreshes until they receive a search request
			# ................................................................................................
			"idle" : {
				"after" : "30s"				# time after a shard stops refreshing in background
			},
		}




		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# CLUSTER SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		# Primary shard settings
		# ................................................................................................
		"number_of_shards" : 3 * count(self::$server_ips),	# define number of shards for the index


# Replica shard settings
# for indexing large amount of data set number of replicas to 0 (toggle before and after large index action)
# according to documentation:
#   - https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-indexing-speed.html#_disable_refresh_and_replicas_for_initial_loads
# ................................................................................................
"number_of_replicas" : 0,			# hard set number of replicas in the index



		# Allocation Settings
		# according to documentation:
		# 	- https://www.elastic.co/guide/en/elasticsearch/reference/7.3/delayed-allocation.html
		"unassigned" : {
			"node_left" : {
				"delayed_timeout" : "1m"	# allocation of replica shards which become unassigned because a node has left can be delayed with this setting
			}
		},


		"allocation" : {
			"max_retries" : "5"				# attempts to allocate a shard
		},


		# Routing settings
		# ................................................................................................
		"routing" : {

			# allocation settings
			# Controls shard allocation for this index
			# ................................................................................................
			"allocation" : {
				"enable" : "all",					# allow shard allocation for all shards
				"total_shards_per_node" : "-1"		# max number of shards per node (-1 = infinity)
			},


			# rebalance settings
			# Controls shard rebalancing for this index
			# ................................................................................................
			"rebalance" : {
				"enable" : "all"	# rebalance all shards if needed
			}
		},


		"auto_expand_replicas" : "false",   				# number of replicas based on nodes in cluster
		"index.shard.check_on_startup" : "checksum",		# prevent shards from beeing opened when corrupted


		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# CACHE SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

# Shard level query caching
# according to documentation:
# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/shard-request-cache.html
# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-search-speed.html#preference-cache-optimization
# ................................................................................................
"requests.cache.enable" : true,		# enable / disable request caching (per shard)
"requests.cache.size" : "1%"		# shard-level request cache size




		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# MERGING PROCESS SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		# Merging Process Settings
		# Lucene controlling options
		# be CAREFUL when touching these !
		# ................................................................................................
		"merge" : {
			"scheduler" : {
				"auto_throttle" : "true",			# enable or disable merging throttle (following options)
				"max_thread_count" : "2",			# The maximum number of threads on a single shard that may be merging at once

				# (not documented in 7.3) 
				# according to:
				# 	- https://www.outcoldman.com/en/archive/2017/07/13/elasticsearch-explaining-merge-settings/
				# ................................................................................................
				"max_merge_count" : "7"
			},
			"policy" : {
				# (not documented in 7.3) 
				# according to:
				# 	- https://www.outcoldman.com/en/archive/2017/07/13/elasticsearch-explaining-merge-settings/
				# ................................................................................................
				"max_merged_segment" : "5gb", 		# maximal size for lucene segment merges
				"max_merge_at_once" : "10",			# max number of segments in one mergeprocess
				"expunge_deletes_allowed" : "10.0", # value in percent

				# (not documented in 7.3)
				# according to:
				# 	- https://www.elastic.co/de/blog/lucenes-handling-of-deleted-documents
				# ................................................................................................
				"reclaim_deletes_weight" : "2.0",	 	# segments with more deletions will be targeted for merging. setting adjust how aggressive
				"floor_segment" : "2mb",			 	# accuracy for segment sizes
				"max_merge_at_once_explicit" : "30", 	# not documented
				"segments_per_tier" : "10.0",			# not documented
				"deletes_pct_allowed" : "33.0"			# not documented
			}
		},
























		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# NODE RELEVANT SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# CACHE SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

# Node level query caching
# according to documentation:
# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/query-cache.html
# 	- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-search-speed.html#preference-cache-optimization
# ................................................................................................
"queries.cache.enabled" : true,		# enable / disable query caching (per node for all shards)
"queries.cache.size" : "10%"		# node-level query cache size




"fielddata" : {
	"cache" : "node"
},





















		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# XPACK FEATURES (XPACK License)
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		# Cross cluster replication settings
		# xpack feature
		# ................................................................................................
		"soft_deletes" : {
			"enabled" : "false",
			"retention" : {
				"operations" : "0"
			},
			"retention_lease" : {
				"period" : "12h"
			}
		},

		"xpack" : {
			"watcher" : {
				"template" : {
					"version" : ""
				}
			},
			"version" : "",
			"ccr" : {
				"following_index" : "false"
			}
		}




		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# UNDOCUMENTED SETTINGS
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		# "source_only" : "false",
		# "force_memory_term_dictionary" : "false",
		# "verified_before_close" : "false",
		# "format" : "0",
		# "frozen" : "false",
		# "compound_format" : "0.1",




		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		# REMOVED SETTINGS IN ES 7.3
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=
		#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=#=-=-=-=-=-=

		# # has been removed in 7.3
		# "warmer" : {
		# 	"enabled" : "true"
		# },


		# # not documented for 7.3
		# "lifecycle" : {
		# 	"name" : "",
		# 	"rollover_alias" : "",
		# 	"indexing_complete" : "false"
		# }
	}
}'




