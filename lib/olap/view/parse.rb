class Olap::View::Parse

  attr_reader :response

  def initialize response
    @response = response
  end

  def aggregate dimension, measures = []
    result = []
    index = {}
    response.rows.each{|row|
      label = row[:labels].detect{|label| label[:name] == dimension}
      values = row[:values].collect{|v|
        next unless measures.include? v[:measure]
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

  def dimensions_caption dimension = nil
    dimension.nil? ? response.dimensions :
        response.dimensions.collect{|d|
          next unless dimension == d[:name]
          d
        }.compact
  end

  def measures_caption measures = []
    (measures.nil? || measures.empty?) ? response.measures :
        response.measures.collect{|m|
          next unless measures.include? m[:name]
          m
        }.compact
  end

  def table dimension = nil, measures = []
    (dimension ? aggregate(dimension, measures) : response.rows).collect{|row|
      row[:labels].collect{|label| {type: 'dimension', value: label[:value].to_s, fmt_value: label[:fmt_value]}} +
          row[:values].collect{|value| {type: 'measure', value: value[:value].to_f, fmt_value: value[:fmt_value]}}
    }
  end

end
