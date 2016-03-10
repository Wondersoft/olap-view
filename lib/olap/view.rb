require "olap/xmla"

require 'olap/view/engine' if ::Rails.version >= '3.1'
require "olap/view/version"
require "olap/view/parse"

module Olap
  module View

    @@view_options = {
        no_data: "Not enough data to display",
        undefined: "-",
        total: "Total"
    }

    def self.default_options= options = {}
      @@view_options.merge(options)
    end

    def self.options
      @@view_options
    end

    def self.request mdx, args = {}
      response = Olap::Xmla.client.request(mdx, args)
      Olap::View::Parse.new response
    end
  end
end
