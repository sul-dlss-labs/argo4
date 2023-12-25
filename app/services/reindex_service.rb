# frozen_string_literal: true

# Reindexes Solr documents as Elasticsearch documents.
# Reindexing involves retrieving a set of Solr documents,
# mapping them to Elasticsearch documents, and performing a
# bulk Elasticsearch index.
class ReindexService
  SOLR_PAGE_SIZE = 1000

  def reindex_single(druid:)
    solr_doc = solr.get('select', params: { q: "id:#{druid}" })['response']['docs'].first
    elasticsearch.index(document: DocMapper.new(solr_doc:).call)
  end

  def reindex(size:, create_index: true)
    ElasticsearchRepository.new.create_index if create_index
    page = 1
    doc_count = 0
    while doc_count < size
      page_size = [size - doc_count, SOLR_PAGE_SIZE].min
      docs = solr.paginate(page, page_size, 'select', params: { q: 'id:*' })['response']['docs'].map do |solr_doc|
        DocMapper.new(solr_doc:).call
      end

      break if docs.empty?

      doc_count += docs.size
      Rails.logger.info("Indexing #{docs.size} documents (page #{page}, total #{doc_count})")
      elasticsearch.bulk_index(documents: docs) if docs.present?
      page += 1
    end
  end

  private

  def solr
    @solr ||= RSolr.connect(url: Settings.solr.url)
  end

  def elasticsearch
    @elasticsearch ||= ElasticsearchRepository.new
  end

  class DocMapper
    def initialize(solr_doc:)
      @solr_doc = solr_doc.with_indifferent_access
    end

    def call
      {
        druid: solr_doc[:id],
        title: solr_doc[:sw_display_title_tesim].first,
        object_type: solr_doc[:objectType_ssim],
        content_type: solr_doc[:content_type_ssim],
        project_tag: solr_doc[:exploded_project_tag_ssim],
        released_to_searchworks_date: solr_doc[:released_to_searchworks_dttsi]
      }
    end

    private

    attr_reader :solr_doc
  end
end
