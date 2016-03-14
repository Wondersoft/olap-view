require "olap/xmla"

require 'olap/view/engine' if ::Rails.version >= '3.1'
require "olap/view/version"
require "olap/view/parse"

module Olap
  module View

    @@default_view_options = {
        no_data: "Not enough data to display",
        undefined: "-",
        total: "Total"
    }

    # Configure the default view options
    # Can be optionally used to setup options in one place in application,
    #
    # Example:
    #   >> Olap::View.default_view_options = {no_data: 'Text for no data', undefined: 'Undefined element name', total: 'Total title'}
    #   >> Olap::View.request mdx
    #   => #<Olap::View::Parse:0x007ffa2b9f60f0 @response=#<Olap::Xmla::Response:0x007ffa2b9f6118 @response={4 ...
    #
    def self.default_view_options= options = {}
      @@default_view_options.merge!(options)
    end

    def self.view_options
      @@default_view_options
    end

    def self.request mdx, args = {}
      response = Olap::Xmla.client.request(mdx, args)
      Olap::View::Parse.new response
    end
  end
end
