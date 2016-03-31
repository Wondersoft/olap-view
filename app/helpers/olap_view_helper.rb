  module OlapViewHelper

    # Initialize Goole Charts API
    # Paste it into <head> to your layout
    #
    # <head>
    # ...
    # <%= olap_view_charts_init %>
    # </head>
    #
    def olap_view_charts_init
      javascript_include_tag 'https://www.google.com/jsapi'
    end

    def olap_view_chart_by_mdx chart, mdx, args={}, properties = {}
      xmla = Olap::View.request mdx, args
      olap_view_chart_by_xmla chart, xmla, properties
    end

    def olap_view_chart_by_xmla chart, xmla, properties = {}
      id = olap_view_random_id

      if xmla.response.rows && !xmla.response.rows.empty?
        html = "<div id='#{id}'></div>"
        html += javascript_tag(render partial: "olap-view/#{chart}.js",
                                      locals: {id: id, data: xmla, properties: properties})
      else
        html = "<div id='#{id}'>#{olap_view_i18n_options[:no_data]}</div>"
      end
      html.html_safe
    end

    def olap_view_render_row row
      row.collect{|r|
        if r[:type] == 'dimension'
          "{v: '#{escape_javascript(r[:value] && !r[:value].empty? ? r[:value] : olap_view_i18n_options[:undefined])}', p:{'type': '#{r[:type]}', className: 'google-visualization-table-td #{r[:type]}'}}"
        else
          "{v: #{r[:value]}, f: '#{r[:fmt_value] || r[:value]}', p:{'type': '#{r[:type]}', className: 'google-visualization-table-td #{r[:type]}'}}"
        end
      }.join(',').html_safe
    end

    def olap_view_filling_table data, dimension = nil, measures = [], merge_dimension = false
      html = ''

      if merge_dimension
        d_caption = data.dimensions_caption(dimension).collect{|d| d[:caption]}.join(', ')
        html += "data.addColumn({type: 'string', label: '#{escape_javascript d_caption}', id: 'merge_dimension', p:{'type': 'dimension'}});\n"
      else
        data.dimensions_caption(dimension).each do |d|
          html += "data.addColumn({type: 'string', label: '#{escape_javascript d[:caption]}', id: '#{escape_javascript d[:name]}', p:{'type': 'dimension'}});\n"
        end
      end
      data.measures_caption(measures).each do |m|
        html += "data.addColumn({type: 'number', label: '#{escape_javascript m[:caption]}', id: '#{escape_javascript m[:name]}', p:{'type': 'measure'}});\n"
      end
      data.table(dimension, measures, merge_dimension).each do |row|
        html += "data.addRow([#{olap_view_render_row row}]);\n"
      end
      html.html_safe
    end

    def olap_view_random_id
      (0...8).map { ('a'..'z').to_a[rand(26)] }.join
    end

    def olap_view_unknown_element
      olap_view_i18n_options[:undefined].html_safe
    end

    def olap_view_i18n_options
      Hash[Olap::View.view_options.collect{|k, v| [k, I18n.t("olap.view.#{k}", default: v).html_safe]}]
    end
  end