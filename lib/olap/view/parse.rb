class Olap::View::Parse

  attr_reader :response

  def initialize response
    @response = response
  end

  # Aggregate result by one of the dimensions and return only listed measures
  def aggregate dimension, measures = []
    result = []
    index = {}
    response.rows.each{|row|
      label = row[:labels].detect{|label| label[:name] == dimension}
      values = row[:values].collect{|v|
        next if !measures.empty? && !measures.include?(v[:measure])
        v.delete :fmt_value
        v
      }.compact

      if i = index[label]
        for j in 0..result[i][:values].count-1
          result[i][:values][j][:value] = result[i][:values][j][:value].to_f + values[j][:value].to_f
        end
      else
        index[label] = result.count
        result << {
            rownum: result.count + 1,
            labels: [label],
            values: values
        }
      end
    }
    result
  end

  # Return collection of dimensions or selected dimension by name
  #
  # *  +:name+  the name of dimension
  # *  +:caption+ display name of dimension
  #
  def dimensions_caption dimension = nil
    dimension.nil? ? response.dimensions :
        response.dimensions.collect{|d|
          next unless dimension == d[:name]
          d
        }.compact
  end

  # Return collection of measures or selected measures by name
  #
  # *  +:name+  the name of measure
  # *  +:caption+ display name of measure
  #
  def measures_caption measures = []
    (measures.nil? || measures.empty?) ? response.measures :
        response.measures.collect{|m|
          next unless measures.include? m[:name]
          m
        }.compact
  end

  def dimensions_row row, merge_dimensions = false
    if merge_dimensions
      label_value = row.collect{|label|
        next if label[:value].to_s.empty?
        label[:value].to_s
      }.compact.join(', ')
      label_fmt_value = row.collect{|label|
        next if label[:fmt_value].to_s.empty?
        label[:fmt_value]
      }.compact.join(', ')
      [{type: 'dimension', value: label_value.to_s, fmt_value: label_fmt_value.to_s}]
    else
      row.collect{|label| {type: 'dimension', value: label[:value].to_s, fmt_value: label[:fmt_value]}}
    end
  end

  def measures_row row, measures = []
    row.collect{|value|
      next if !measures.empty? && !measures.include?(value[:measure])
      {type: 'measure', value: value[:value].to_f, fmt_value: value[:fmt_value]}
    }.compact
  end

  # Collection of result rows and aggregate collection by dimension and measures
  #      type - dimension or measure
  #      value - metric value
  #      fmt_value - formatted metric value
  def table dimension = nil, measures = [], merge_dimensions = false
    (dimension && !measures.empty? ? aggregate(dimension, measures) : response.rows).collect{|row|
      dimensions_row(row[:labels], merge_dimensions) + measures_row(row[:values], measures)
    }
  end

end
