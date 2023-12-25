# frozen_string_literal: true

namespace :index do
  desc 'Reindex from Solr'
  task :reindex, [:size] => :environment do |_task, args|
    args.with_defaults(size: 10_000)
    ReindexService.new.reindex(size: args[:size].to_i)
  end
end
