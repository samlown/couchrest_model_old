module CouchRest
  module Model
    module Designs

      class Elastic
        include Enumerable

        attr_accessor :model, :name, :query, :result, :request

        def initialize(model, query = {}, name = nil, filter_name = nil)
          self.model = model
          self.query = query
          @request = {
            "type" => "couchdb",
            "couchdb" => {
              "host" => "localhost",
              "port" => 5984,
              "db"   => nil, # database name
              "filter" => filter_name
            }
          }
          @request["index"] = {
              "index" => {
                "index" => nil, # database name
                "type"  => model.to_s.underscore
              }
            }.update(opts['index'] || {})


        end


        # == Search execution methods

        def rows

        end


      end

      # A special wrapper class that provides easy access to the key
      # fields in a result row.
      class ElasticSearchRow < Hash
        attr_reader :model
        def initialize(hash, model)
          @model    = model
          replace(hash)
        end
        def id
          self["id"]
        end
        def key
          self["key"]
        end
        def value
          self['value']
        end
        def raw_doc
          self['doc']
        end
        # Send a request for the linked document either using the "id" field's
        # value, or the ["value"]["_id"] used for linked documents.
        def doc
          return model.build_from_database(self['_source']) if self['_source']
          doc_id = (value.is_a?(Hash) && value['_id']) ? value['_id'] : self.id
          doc_id ? model.get(doc_id) : nil
        end
      end



    end
  end
end
