# Argo-Quatro

A proof-of-concept for providing Argo search functionality using Elasticsearch and without Blacklight.

## Search
### Configuration
The primary configuration for search is the `Search` model. In addition to containing attributes for the query, page, and page size, it contains an attribute for each facet.

A facet attribute is a type `Type::Facet`. For example:
```
  attribute :object_type, Type::Facet.new(
    label: 'Object Type'), default: []
```
Facets are arrays.

A facet can be configured with an aggregation proc. The aggregation proc generates the Elasticsearch Aggregation DSL for the facet. This DSL is used to retrieve the facet values and counts. For example:
```
    agg_proc: ElasticsearchAggregations::Tags
```
The default aggregration proc is `ElasticsearchAggregations::Terms`, which generates a `terms` aggregation.

A facet can be configured with an aggregation response proc. The aggregation response proc parses the aggregation response from Elasticsearch to get the facet values and counts. For example:
```
    agg_response_proc: ElasticsearchAggregationResponses::Date,
```
The default aggregation response proc is `ElasticsearchAggregationResponses::Value`.

A facet can be configured with a filter proc. The filter proc generates the Query DSL for the facet. This DSL limits the query and facet results for the selected facet values. For example:
```
    filter_proc: ElasticsearchFilters::ReleasedToSearchworksDate
```
The default filter proc is `ElasticsearchFilters::Terms`.

A facet can be configured with a component. The component is used to render the facet. For example:
```
    component: HierarchicalFacetComponent
```
The default component is `FacetComponent`.

### Search process
Searching is initiated by calling the `SearchService` with a populated `Search` model. This will invoke a `SearchJob` and one or more `FacetSearchJob`s.

The Search Job will perform will query Elasticsearch for documents and some aggregations. (These should be fast aggregations only; slow aggregations should be performed by a separate Facet Search Job.) The documents and the aggregations will be Turbo broadcasted.

A Facet Search Job will be performed for each facet that is configured with `multi: false`. For example:
```
  attribute :project_tag, Type::Facet.new(
    label: 'Project Tag', 
    multi: false,
    agg_proc: ElasticsearchAggregations::Tags,
    component: HierarchicalFacetComponent), default: []
```
Facet Search Job should be performed for slow facets (as they require a separate Elasticsearch query). The job will Turbo broadcast the aggregation.

### Display
Result documents and facets are all asynchronously rendered by Turbo streams; broadcasts are performed by the search jobs.

For both results lists and item details pages, items are represented by `ItemPresenter`s rather than directly by Elasticsearch source documents or Cocina items.


### Adding a facet
1. Add index field configuration to `app/services/create_index.rb`. (Note: Currently, the index must be deleted and recreated to change the index configuration. In the future, the index field configuration could just be updated.)
2. Add permitted parameter to `app/controllers/searches_controller.rb`.
3. Add facet configuration to `app/models/search.rb`.
4. Optionally, create an aggregation proc, aggregation proc, filter proc, and/or a facet component.

## Running locally
```
docker compose up
docker cp argo4-es01-1:/usr/share/elasticsearch/config/certs/ca/ca.crt tmp/.
bin/dev
```

Note that Kibana will be running at http://localhost:5601


## Indexing
Currently, the index is generated from Solr documents.
```
bin/rake "index:reindex[100000]"
```

To tunnel to production Solr:
```
ssh -L 8983:sul-solr-prod-a.stanford.edu:80 lyberadmin@argo-prod-02.stanford.edu
```
