% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/search.r
\name{Search}
\alias{Search}
\title{Full text search of Elasticsearch}
\usage{
Search(
  conn,
  index = NULL,
  type = NULL,
  q = NULL,
  df = NULL,
  analyzer = NULL,
  default_operator = NULL,
  explain = NULL,
  source = NULL,
  fields = NULL,
  sort = NULL,
  track_scores = NULL,
  timeout = NULL,
  terminate_after = NULL,
  from = NULL,
  size = NULL,
  search_type = NULL,
  lowercase_expanded_terms = NULL,
  analyze_wildcard = NULL,
  version = NULL,
  lenient = FALSE,
  body = list(),
  raw = FALSE,
  asdf = FALSE,
  track_total_hits = TRUE,
  time_scroll = NULL,
  search_path = "_search",
  stream_opts = list(),
  ...
)
}
\arguments{
\item{conn}{an Elasticsearch connection object, see \code{\link{connect}}}

\item{index}{Index name, one or more}

\item{type}{Document type. Note that \code{type} is deprecated in
Elasticsearch v7 and greater, and removed in Elasticsearch v8. We will
strive to support types for folks using older ES versions}

\item{q}{The query string (maps to the query_string query, see Query String
Query for more details). See
https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html
for documentation and examples.}

\item{df}{(character) The default field to use when no field prefix is
defined within the query.}

\item{analyzer}{(character) The analyzer name to be used when analyzing the
query string.}

\item{default_operator}{(character) The default operator to be used, can be
\code{AND} or \code{OR}. Default: \code{OR}}

\item{explain}{(logical) For each hit, contain an explanation of how
scoring of the hits was computed. Default: \code{FALSE}}

\item{source}{(logical) Set to \code{FALSE} to disable retrieval of the
\code{_source} field. You can also retrieve part of the document by
using \code{_source_include} & \code{_source_exclude} (see the \code{body}
documentation for more details). You can also include a comma-delimited
string of fields from the source document that you want back. See also
the \strong{fields} parameter}

\item{fields}{(character) The selective stored fields of the document to
return for each hit. Not specifying any value will cause no fields to return.
Note that in Elasticsearch v5 and greater, \strong{fields} parameter has
changed to \strong{stored_fields}, which is not on by default. You can
however, pass fields to \strong{source} parameter}

\item{sort}{(character) Sorting to perform. Can either be in the form of
fieldName, or \code{fieldName:asc}/\code{fieldName:desc}. The fieldName
can either be an actual field within the document, or the special
\code{_score} name to indicate sorting based on scores. There can be several
sort parameters (order is important).}

\item{track_scores}{(logical) When sorting, set to \code{TRUE} in order to
still track scores and return them as part of each hit.}

\item{timeout}{(numeric) A search timeout, bounding the search request to
be executed within the specified time value and bail with the hits
accumulated up to that point when expired. Default: no timeout.}

\item{terminate_after}{(numeric) The maximum number of documents to collect
for each shard, upon reaching which the query execution will terminate
early. If set, the response will have a boolean field terminated_early to
indicate whether the query execution has actually terminated_early.
Default: no terminate_after}

\item{from}{(character) The starting from index of the hits to return.
Pass in as a character string to avoid problems with large number
conversion to scientific notation. Default: 0}

\item{size}{(character) The number of hits to return. Pass in as a
character string to avoid problems with large number conversion to
scientific notation. Default: 10. The default maximum is 10,000 - however,
you can change this default maximum by changing the
\code{index.max_result_window} index level parameter.}

\item{search_type}{(character) The type of the search operation to perform.
Can be \code{query_then_fetch} (default) or \code{dfs_query_then_fetch}.
Types \code{scan} and \code{count} are deprecated.
See \url{http://bit.ly/19Am9xP} for more details on the different types of
search that can be performed.}

\item{lowercase_expanded_terms}{(logical) Should terms be automatically
lowercased or not. Default: \code{TRUE}.}

\item{analyze_wildcard}{(logical) Should wildcard and prefix queries be
analyzed or not. Default: \code{FALSE}.}

\item{version}{(logical) Print the document version with each document.}

\item{lenient}{(logical) If \code{TRUE} will cause format based failures (like
providing text to a numeric field) to be ignored. Default: \code{FALSE}}

\item{body}{Query, either a list or json.}

\item{raw}{(logical) If \code{FALSE} (default), data is parsed to list.
If \code{TRUE}, then raw JSON returned}

\item{asdf}{(logical) If \code{TRUE}, use \code{\link[jsonlite]{fromJSON}}
to parse JSON directly to a data.frame. If \code{FALSE} (Default), list
output is given.}

\item{track_total_hits}{(logical, numeric) If \code{TRUE} will always track
the number of hits that match the query accurately. If \code{FALSE} will
count documents accurately up to 10000 documents. If \code{is.integer} will
count documents accurately up to the number. Default: \code{TRUE}}

\item{time_scroll}{(character) Specify how long a consistent view of the
index should be maintained for scrolled search, e.g., "30s", "1m". See
\link{units-time}}

\item{search_path}{(character) The path to use for searching. Default
to \verb{_search}, but in some cases you may already have that in the base
url set using \code{\link[=connect]{connect()}}, in which case you can set this
to \code{NULL}}

\item{stream_opts}{(list) A list of options passed to
\code{\link[jsonlite]{stream_out}} - Except that you can't pass \code{x} as
that's the data that's streamed out, and pass a file path instead of a
connection to \code{con}. \code{pagesize} param doesn't do much as
that's more or less controlled by paging with ES.}

\item{...}{Curl args passed on to \code{\link[crul]{verb-POST}}}
}
\description{
Full text search of Elasticsearch
}
\details{
This function name has the "S" capitalized to avoid conflict with the function
\code{base::search}. I hate mixing cases, as I think it confuses users, but in this case
it seems neccessary.
}
\section{profile}{

The Profile API provides detailed timing information about the execution of
individual components in a search request. See
https://www.elastic.co/guide/en/elasticsearch/reference/current/search-profile.html
for more information

In a body query, you can set to \code{profile: true} to enable profiling
results. e.g.

\preformatted{
{
  "profile": true,
  "query" : {
    "match" : { "message" : "some number" }
  }
}
}
}

\examples{
\dontrun{
# make connection object
(x <- connect())

# load some data
if (!index_exists(x, "shakespeare")) {
  shakespeare <- system.file("examples", "shakespeare_data.json",
    package = "elastic")
  shakespeare <- type_remover(shakespeare)
  invisible(docs_bulk(x, shakespeare))
}
if (!index_exists(x, "gbif")) {
  gbif <- system.file("examples", "gbif_data.json",
    package = "elastic")
  gbif <- type_remover(gbif)
  invisible(docs_bulk(x, gbif))
}
if (!index_exists(x, "plos")) {
  plos <- system.file("examples", "plos_data.json",
    package = "elastic")
  plos <- type_remover(plos)
  invisible(docs_bulk(x, plos))
}


# URI string queries
Search(x, index="shakespeare")
## if you're using an older ES version, you may have types
if (gsub("\\\\.", "", x$ping()$version$number) < 700) {
  Search(x, index="shakespeare", type="act")
  Search(x, index="shakespeare", type="scene")
  Search(x, index="shakespeare", type="line")
}

## Return certain fields
if (gsub("\\\\.", "", x$ping()$version$number) < 500) {
  ### ES < v5
  Search(x, index="shakespeare", fields=c('play_name','speaker'))
} else {
  ### ES > v5
  Search(x, index="shakespeare", body = '{
   "_source": ["play_name", "speaker"]
  }')
}

## Search multiple indices
Search(x, index = "gbif")$hits$total$value
Search(x, index = "shakespeare")$hits$total$value
Search(x, index = c("gbif", "shakespeare"))$hits$total$value

## search_type
Search(x, index="shakespeare", search_type = "query_then_fetch")
Search(x, index="shakespeare", search_type = "dfs_query_then_fetch")
### search type "scan" is gone - use time_scroll instead
Search(x, index="shakespeare", time_scroll = "2m")
### search type "count" is gone - use size=0 instead
Search(x, index="shakespeare", size = 0)$hits$total$value

## search exists check
### use size set to 0 and terminate_after set to 1
### if there are > 0 hits, then there are matching documents
Search(x, index="shakespeare", size = 0, terminate_after = 1)

## sorting
### if ES >5, we need to make sure fielddata is turned on for a field 
### before using it for sort 
if (gsub("\\\\.", "", x$ping()$version$number) >= 500) {
 if (index_exists(x, "shakespeare")) index_delete(x, "shakespeare")
 index_create(x, "shakespeare")
 mapping_create(x, "shakespeare", body = '{
    "properties": {
      "speaker": { 
        "type":     "text",
        "fielddata": true
      }
    }
  }'
 )
 shakespeare <- system.file("examples", "shakespeare_data.json",
   package = "elastic")
 shakespeare <- type_remover(shakespeare)
 invisible(docs_bulk(x, shakespeare))
 z <- Search(x, index="shakespeare", sort="speaker", size = 30)
 vapply(z$hits$hits, function(w) w$`_source`$speaker, "")
}

if (gsub("\\\\.", "", x$ping()$version$number) < 500) {
  Search(x, index="shakespeare", type="line", sort="speaker:desc", 
    fields='speaker')
  Search(x, index="shakespeare", type="line",
    sort=c("speaker:desc","play_name:asc"), fields=c('speaker','play_name'))
}


## pagination
Search(x, index="shakespeare", size=1)$hits$hits
Search(x, index="shakespeare", size=1, from=1)$hits$hits

## queries
### Search in all fields
Search(x, index="shakespeare", q="york")

### Searchin specific fields
Search(x, index="shakespeare", q="speaker:KING HENRY IV")$hits$total$value

### Exact phrase search by wrapping in quotes
Search(x, index="shakespeare", q='speaker:"KING HENRY IV"')$hits$total$value

### can specify operators between multiple words parenthetically
Search(x, index="shakespeare", q="speaker:(HENRY OR ARCHBISHOP)")$hits$total$value

### where the field line_number has no value (or is missing)
Search(x, index="shakespeare", q="_missing_:line_number")$hits$total$value

### where the field line_number has any non-null value
Search(x, index="shakespeare", q="_exists_:line_number")$hits$total$value

### wildcards, either * or ?
Search(x, index="shakespeare", q="*ay")$hits$total$value
Search(x, index="shakespeare", q="m?y")$hits$total$value

### regular expressions, wrapped in forward slashes
Search(x, index="shakespeare", q="text_entry:/[a-z]/")$hits$total$value

### fuzziness
Search(x, index="shakespeare", q="text_entry:ma~")$hits$total$value
Search(x, index="shakespeare", q="text_entry:the~2")$hits$total$value
Search(x, index="shakespeare", q="text_entry:the~1")$hits$total$value

### Proximity searches
Search(x, index="shakespeare", q='text_entry:"as hath"~5')$hits$total$value
Search(x, index="shakespeare", q='text_entry:"as hath"~10')$hits$total$value

### Ranges, here where line_id value is between 10 and 20
Search(x, index="shakespeare", q="line_id:[10 TO 20]")$hits$total$value

### Grouping
Search(x, index="shakespeare", q="(hath OR as) AND the")$hits$total$value

# Limit number of hits returned with the size parameter
Search(x, index="shakespeare", size=1)

# Give explanation of search in result
Search(x, index="shakespeare", size=1, explain=TRUE)

## terminate query after x documents found
## setting to 1 gives back one document for each shard
Search(x, index="shakespeare", terminate_after=1)
## or set to other number
Search(x, index="shakespeare", terminate_after=2)

## Get version number for each document
Search(x, index="shakespeare", version=TRUE, size=2)

## Get raw data
Search(x, index="shakespeare", raw = TRUE)

## Curl options 
### verbose 
out <- Search(x, index="shakespeare", verbose = TRUE)


# Query DSL searches - queries sent in the body of the request
## Pass in as an R list

### if ES >5, we need to make sure fielddata is turned on for a field 
### before using it for aggregations 
if (gsub("\\\\.", "", x$ping()$version$number) >= 500) {
  mapping_create(x, "shakespeare", update_all_types = TRUE, body = '{
    "properties": {
      "text_entry": { 
        "type":     "text",
        "fielddata": true
     }
   }
 }')
 aggs <- list(aggs = list(stats = list(terms = list(field = "text_entry"))))
 Search(x, index="shakespeare", body=aggs)
}

### if ES >5, you don't need to worry about fielddata
if (gsub("\\\\.", "", x$ping()$version$number) < 500) {
   aggs <- list(aggs = list(stats = list(terms = list(field = "text_entry"))))
   Search(x, index="shakespeare", body=aggs)
}

## or pass in as json query with newlines, easy to read
aggs <- '{
    "aggs": {
        "stats" : {
            "terms" : {
                "field" : "speaker"
            }
        }
    }
}'
Search(x, index="shakespeare", body=aggs, asdf=TRUE, size = 0)

## or pass in collapsed json string
aggs <- '{"aggs":{"stats":{"terms":{"field":"text_entry"}}}}'
Search(x, index="shakespeare", body=aggs)


## Aggregations
### Histograms
aggs <- '{
    "aggs": {
        "latbuckets" : {
           "histogram" : {
               "field" : "decimalLatitude",
               "interval" : 5
           }
        }
    }
}'
Search(x, index="gbif", body=aggs, size=0)

### Histograms w/ more options
aggs <- '{
    "aggs": {
        "latbuckets" : {
           "histogram" : {
               "field" : "decimalLatitude",
               "interval" : 5,
               "min_doc_count" : 0,
               "extended_bounds" : {
                   "min" : -90,
                   "max" : 90
               }
           }
        }
    }
}'
Search(x, index="gbif", body=aggs, size=0)

### Ordering the buckets by their doc_count - ascending:
aggs <- '{
    "aggs": {
        "latbuckets" : {
           "histogram" : {
               "field" : "decimalLatitude",
               "interval" : 5,
               "min_doc_count" : 0,
               "extended_bounds" : {
                   "min" : -90,
                   "max" : 90
               },
               "order" : {
                   "_count" : "desc"
               }
           }
        }
    }
}'
out <- Search(x, index="gbif", body=aggs, size=0)
lapply(out$aggregations$latbuckets$buckets, data.frame)

### By default, the buckets are returned as an ordered array. It is also possible to
### request the response as a hash instead keyed by the buckets keys:
aggs <- '{
    "aggs": {
        "latbuckets" : {
           "histogram" : {
               "field" : "decimalLatitude",
               "interval" : 10,
               "keyed" : true
           }
        }
    }
}'
Search(x, index="gbif", body=aggs, size=0)

# match query
match <- '{"query": {"match" : {"text_entry" : "Two Gentlemen"}}}'
Search(x, index="shakespeare", body=match)

# multi-match (multiple fields that is) query
mmatch <- '{"query": {"multi_match" : {"query" : "henry", "fields": ["text_entry","play_name"]}}}'
Search(x, index="shakespeare", body=mmatch)

# bool query
mmatch <- '{
 "query": {
   "bool" : {
     "must_not" : {
       "range" : {
         "speech_number" : {
           "from" : 1, "to": 5
}}}}}}'
Search(x, index="shakespeare", body=mmatch)

# Boosting query
boost <- '{
 "query" : {
  "boosting" : {
      "positive" : {
          "term" : {
              "play_name" : "henry"
          }
      },
      "negative" : {
          "term" : {
              "text_entry" : "thou"
          }
      },
      "negative_boost" : 0.8
    }
 }
}'
Search(x, index="shakespeare", body=boost)

# Fuzzy query
## fuzzy query on numerics
fuzzy <- list(query = list(fuzzy = list(text_entry = "arms")))
Search(x, index="shakespeare", body=fuzzy)$hits$total$value
fuzzy <- list(query = list(fuzzy = list(text_entry = list(value = "arms", fuzziness = 4))))
Search(x, index="shakespeare", body=fuzzy)$hits$total$value

# geoshape query
## not working yets
geo <- list(query = list(geo_shape = list(location = list(shape = list(type = "envelope",
   coordinates = "[[2,10],[10,20]]")))))
geo <- '{
 "query": {
   "geo_shape": {
     "location": {
       "point": {
         "type": "envelope",
         "coordinates": [[2,0],[2.93,100]]
       }
     }
   }
 }
}'
# Search(x, index="gbifnewgeo", body=geo)

# range query
## with numeric
body <- list(query=list(range=list(decimalLongitude=list(gte=1, lte=3))))
Search(x, 'gbif', body=body)$hits$total$value

body <- list(query=list(range=list(decimalLongitude=list(gte=2.9, lte=10))))
Search(x, 'gbif', body=body)$hits$total$value

## with dates
body <- list(query=list(range=list(eventDate=list(gte="2012-01-01", lte="now"))))
Search(x, 'gbif', body=body)$hits$total$value

body <- list(query=list(range=list(eventDate=list(gte="2014-01-01", lte="now"))))
Search(x, 'gbif', body=body)$hits$total$value

# more like this query (more_like_this can be shortened to mlt)
body <- '{
 "query": {
   "more_like_this": {
     "fields": ["title"],
     "like": "and then",
     "min_term_freq": 1,
     "max_query_terms": 12
   }
 }
}'
Search(x, 'plos', body=body)$hits$total$value

body <- '{
 "query": {
   "more_like_this": {
     "fields": ["abstract","title"],
     "like": "cell",
     "min_term_freq": 1,
     "max_query_terms": 12
   }
 }
}'
Search(x, 'plos', body=body)$hits$total$value

# Highlighting
body <- '{
 "query": {
   "query_string": {
     "query" : "cell"
   }
 },
 "highlight": {
   "fields": {
     "title": {"number_of_fragments": 2}
   }
 }
}'
out <- Search(x, 'plos', body=body)
out$hits$total$value
sapply(out$hits$hits, function(x) x$`_source`$title[[1]])

### Common terms query
body <- '{
 "query" : {
   "match": {
      "text_entry": {
         "query": "this is"
      }
   }
 }
}'
Search(x, 'shakespeare', body=body)

## Scrolling search - instead of paging
res <- Search(x, index = 'shakespeare', q="a*", time_scroll="1m")
scroll(x, res$`_scroll_id`)

res <- Search(x, index = 'shakespeare', q="a*", time_scroll="5m")
out <- list()
hits <- 1
while(hits != 0){
  res <- scroll(x, res$`_scroll_id`)
  hits <- length(res$hits$hits)
  if(hits > 0)
    out <- c(out, res$hits$hits)
}

### Sliced scrolling
#### For scroll queries that return a lot of documents it is possible to 
#### split the scroll in multiple slices which can be consumed independently
body1 <- '{
  "slice": {
    "id": 0, 
    "max": 2 
  },
  "query": {
    "match" : {
      "text_entry" : "a*"
    }
  }
}'

body2 <- '{
  "slice": {
    "id": 1, 
    "max": 2 
  },
  "query": {
    "match" : {
      "text_entry" : "a*"
    }
  }
}'

res1 <- Search(x, index = 'shakespeare', time_scroll="1m", body = body1)
res2 <- Search(x, index = 'shakespeare', time_scroll="1m", body = body2)
scroll(x, res1$`_scroll_id`)
scroll(x, res2$`_scroll_id`)

out1 <- list()
hits <- 1
while(hits != 0){
  tmp1 <- scroll(x, res1$`_scroll_id`)
  hits <- length(tmp1$hits$hits)
  if(hits > 0)
    out1 <- c(out1, tmp1$hits$hits)
}

out2 <- list()
hits <- 1
while(hits != 0) {
  tmp2 <- scroll(x, res2$`_scroll_id`)
  hits <- length(tmp2$hits$hits)
  if(hits > 0)
    out2 <- c(out2, tmp2$hits$hits)
}

c(
 lapply(out1, "[[", "_source"),
 lapply(out2, "[[", "_source")
) 



# Using filters
## A bool filter
body <- '{
 "query":{
   "bool": {
     "must_not" : {
       "range" : {
         "year" : { "from" : 2011, "to" : 2012 }
       }
     }
   }
 }
}'
Search(x, 'gbif', body = body)$hits$total$value

## Geo filters - fun!
### Note that filers have many geospatial filter options, but queries 
### have fewer, andrequire a geo_shape mapping

body <- '{
 "mappings": {
     "properties": {
         "location" : {"type" : "geo_point"}
      }
   }
}'
index_recreate(x, index='gbifgeopoint', body=body)
path <- system.file("examples", "gbif_geopoint.json",
  package = "elastic")
path <- type_remover(path)
invisible(docs_bulk(x, path))

### Points within a bounding box
body <- '{
 "query":{
   "bool" : {
     "must" : {
       "match_all" : {}
     },
     "filter":{
        "geo_bounding_box" : {
          "location" : {
            "top_left" : {
              "lat" : 60,
              "lon" : 1
            },
            "bottom_right" : {
              "lat" : 40,
              "lon" : 14
            }
          }
       }
     }
   }
 }
}'
out <- Search(x, 'gbifgeopoint', body = body, size = 300)
out$hits$total$value
do.call(rbind, lapply(out$hits$hits, function(x) x$`_source`$location))

### Points within distance of a point
body <- '{
"query": {
  "bool" : {
    "must" : {
      "match_all" : {}
    },
   "filter" : {
     "geo_distance" : {
       "distance" : "200km",
       "location" : {
         "lon" : 4,
         "lat" : 50
       }
     }
  }
}}}'
out <- Search(x, 'gbifgeopoint', body = body)
out$hits$total$value
do.call(rbind, lapply(out$hits$hits, function(x) x$`_source`$location))

### Points within distance range of a point
body <- '{
 "aggs":{
   "points_within_dist" : {
     "geo_distance" : {
        "field": "location",
        "origin" : "4, 50",
        "ranges": [ 
          {"from" : 200},
          {"to" : 400}
         ]
     }
   }
 }
}'
out <- Search(x, 'gbifgeopoint', body = body)
out$hits$total$value
do.call(rbind, lapply(out$hits$hits, function(x) x$`_source`$location))

### Points within a polygon
body <- '{
 "query":{
   "bool" : {
     "must" : {
       "match_all" : {}
     },
     "filter":{
        "geo_polygon" : {
          "location" : {
             "points" : [
               [80.0, -20.0], [-80.0, -20.0], [-80.0, 60.0], [40.0, 60.0], [80.0, -20.0]
             ]
           }
         }
       }
     }
   }
}'
out <- Search(x, 'gbifgeopoint', body = body)
out$hits$total$value
do.call(rbind, lapply(out$hits$hits, function(x) x$`_source`$location))

### Geoshape filters using queries instead of filters
#### Get data with geojson type location data loaded first
body <- '{
 "mappings": {
     "properties": {
         "location" : {"type" : "geo_shape"}
      }
   }
}'
index_recreate(x, index='geoshape', body=body)
path <- system.file("examples", "gbif_geoshape.json",
  package = "elastic")
path <- type_remover(path)
invisible(docs_bulk(x, path))

#### Get data with a square envelope, w/ point defining upper left and the other
#### defining the lower right
body <- '{
 "query":{
   "geo_shape" : {
     "location" : {
         "shape" : {
           "type": "envelope",
            "coordinates": [[-30, 50],[30, 0]]
         }
       }
     }
   }
}'
out <- Search(x, 'geoshape', body = body)
out$hits$total$value

#### Get data with a circle, w/ point defining center, and radius
body <- '{
 "query":{
   "geo_shape" : {
     "location" : {
         "shape" : {
           "type": "circle",
           "coordinates": [-10, 45],
           "radius": "2000km"
         }
       }
     }
   }
}'
out <- Search(x, 'geoshape', body = body)
out$hits$total$value

#### Use a polygon, w/ point defining center, and radius
body <- '{
 "query":{
   "geo_shape" : {
     "location" : {
         "shape" : {
           "type": "polygon",
           "coordinates":  [
              [ [80.0, -20.0], [-80.0, -20.0], [-80.0, 60.0], [40.0, 60.0], [80.0, -20.0] ]
           ]
         }
       }
     }
   }
}'
out <- Search(x, 'geoshape', body = body)
out$hits$total$value


# Geofilter with WKT
# format follows "BBOX (minlon, maxlon, maxlat, minlat)"
body <- '{
    "query": {
        "bool" : {
            "must" : {
                "match_all" : {}
            },
            "filter" : {
                "geo_bounding_box" : {
                    "location" : {
                        "wkt" : "BBOX (1, 14, 60, 40)"
                    }
                }
            }
        }
    }
}'
out <- Search(x, 'gbifgeopoint', body = body)
out$hits$total$value



# Missing filter
if (gsub("\\\\.", "", x$ping()$version$number) < 500) {
  ### ES < v5
  body <- '{
   "query":{
     "constant_score" : {
       "filter" : {
         "missing" : { "field" : "play_name" }
       }
     }
    }
  }'
  Search(x, "shakespeare", body = body)
} else {
  ### ES => v5
  body <- '{
   "query":{
     "bool" : {
       "must_not" : {
         "exists" : { 
           "field" : "play_name" 
         }
       }
    }
   }
  }'
  Search(x, "shakespeare", body = body)
}

# prefix filter
body <- '{
 "query": {
   "bool": {
     "must": {
       "prefix" : {
         "speaker" : "we"
       }
     }
   }
 }
}'
z <- Search(x, "shakespeare", body = body)
z$hits$total$value
vapply(z$hits$hits, "[[", "", c("_source", "speaker"))


# ids filter
if (gsub("\\\\.", "", x$ping()$version$number) < 500) {
  ### ES < v5
  body <- '{
   "query":{
     "bool": {
       "must": {
         "ids" : {
           "values": ["1","2","10","2000"]
        }
      }
    }
   }
  }'
  z <- Search(x, "shakespeare", body = body)
  z$hits$total$value
  identical(
   c("1","2","10","2000"),
   vapply(z$hits$hits, "[[", "", "_id")
  )
} else {
  body <- '{
   "query":{
     "ids" : {
       "values": ["1","2","10","2000"]
     }
   }
  }'
  z <- Search(x, "shakespeare", body = body)
  z$hits$total$value
  identical(
   c("1","2","10","2000"),
   vapply(z$hits$hits, "[[", "", "_id")
  )
}

# combined prefix and ids filters
if (gsub("\\\\.", "", x$ping()$version$number) < 500) {
  ### ES < v5
  body <- '{
   "query":{
     "bool" : {
       "should" : {
         "or": [{
           "ids" : {
             "values": ["1","2","3","10","2000"]
           }
         }, {
         "prefix" : {
           "speaker" : "we"
         }
        }
      ]
     }
    }
   }
  }'
  z <- Search(x, "shakespeare", body = body)
  z$hits$total$value
} else {
  ### ES => v5
  body <- '{
   "query":{
     "bool" : {
       "should" : [
         {
           "ids" : {
             "values": ["1","2","3","10","2000"]
           }
         }, 
         {
           "prefix" : {
             "speaker" : "we"
           }
         }
      ]
     }
    }
  }'
  z <- Search(x, "shakespeare", body = body)
  z$hits$total$value
}

# Suggestions
sugg <- '{
 "query" : {
    "match" : {
      "text_entry" : "late"
     }
 },  
 "suggest" : {
   "sugg" : {
     "text" : "late",
     "term" : {
         "field" : "text_entry"
      }
    }
  }
}'
Search(x, index = "shakespeare", body = sugg, 
  asdf = TRUE, size = 0)$suggest$sugg$options



# stream data out using jsonlite::stream_out
file <- tempfile()
res <- Search(x, "shakespeare", size = 1000, stream_opts = list(file = file))
head(df <- jsonlite::stream_in(file(file)))
NROW(df)
unlink(file)


# get profile data
body <- '{
  "profile": true,
  "query" : {
    "match" : { "text_entry" : "war" }
  }
}'
res <- Search(x, "shakespeare", body = body)
res$profile
# time in nanoseconds across each of the shards
vapply(res$profile$shards, function(w) {
  w$searches[[1]]$query[[1]]$time_in_nanos
}, 1)
}
}
\references{
\url{https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html}
\url{https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html}
}
\seealso{
\code{\link[=Search_uri]{Search_uri()}} \code{\link[=Search_template]{Search_template()}} \code{\link[=scroll]{scroll()}} \code{\link[=count]{count()}}
\code{\link[=validate]{validate()}} \code{\link[=fielddata]{fielddata()}}
}
