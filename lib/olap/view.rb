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

    # Configure the default options to connect to XMLA server
    # Can be optionally used to setup connection options in one place in application,
    #
    # Example:
    #   >> Olap::View.default_options = {no_data: 'Text for no data', undefined: 'Undefined element name', total: 'Total title'}
    #   >> Olap::View.request mdx
    #   => #<Olap::View::Parse:0x007ffa2b9f60f0 @response=#<Olap::Xmla::Response:0x007ffa2b9f6118 @response={4 ...
    #
    #
    #
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
