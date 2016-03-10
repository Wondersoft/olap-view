  module OlapViewHelper

    def olap_view_charts_init
      javascript_include_tag 'https://www.google.com/jsapi'
    end

    def olap_view_chart_by_mdx chart, mdx, args={}, properties = {}
      xmla = Olap::View.request mdx, args
      olap_view_chart_by_xmla chart, xmla, properties
    end

    def olap_view_chart_by_xmla chart, xmla, properties = {}
      id = random_id

      if xmla.response.rows && !xmla.response.rows.empty?
        html = "<div id='#{id}'></div>"
        html += javascript_tag(render partial: "olap-view/#{chart}.js",
                                      locals: {id: id, data: xmla, properties: properties})
      else
        html = "<div id='#{id}'>#{Olap::View.options[:no_data]}</div>"
      end
      html.html_safe
    end

    def render_row row
      row.collect{|r|
        if r[:type] == 'dimension'
          "{v: '#{escape_javascript(r[:value] && !r[:value].empty? ? r[:value] : unknown_element)}', p:{className: 'google-visualization-table-td #{r[:type]}'}}"
        else
          "{v: #{r[:value]}, f: '#{r[:fmt_value] || r[:value]}', p:{className: 'google-visualization-table-td #{r[:type]}'}}"
        end
      }.join(',').html_safe
    end

    def filling_table data, dimension = nil, measures = []
      html = ''
      data.dimensions_caption(dimension).each do |d|
        html += "data.addColumn({type: 'string', label: '#{escape_javascript d[:caption]}', id: '#{escape_javascript d[:name]}', p:{'type': 'dimension'}});"
      end
      data.measures_caption(measures).each do |m|
        html += "data.addColumn({type: 'number', label: '#{escape_javascript m[:caption]}', id: '#{escape_javascript m[:name]}', p:{'type': 'measure'}});"
      end
      data.table(dimension, measures).each do |row|
        html += "data.addRow([#{render_row row}]);"
      end
      html.html_safe
    end

    private
    def random_id
      (0...8).map { ('a'..'z').to_a[rand(26)] }.join
    end

    def unknown_element
      Olap::View.options[:undefined].html_safe
    end

    def no_data
      Olap::View.options[:no_data].html_safe
    end

  end