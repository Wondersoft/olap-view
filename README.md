# Olap::View

Ruby On Rails gem to visualize by Google Charts MDX queries on OLAP databases using XMLA connection. Can be used with any XMLA-compliant server, like Olaper or Mondrian.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'olap-view'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install olap-view

## Usage
### Include required files in the application

Include Olap::View helper to `application_helper.rb`

```ruby
include OlapViewHelper
```

Import olap-view Sass file (for example, `application.scss`) to get all of olap-view style:

```sass
@import "olap-view/olap-view";
```

Add Google Charts initialize into `<head>` tag in your laoyut (for examlpe, `application.html.erb`):
 
```html
<head>
...
<%= olap_view_charts_init %>
</head>
```

### Configuration in Rails

### Querying MDX
This gem use `olap-xmla` ( https://github.com/Wondersoft/olap-xmla ) and does not parse MDX, just passes it to XMLA server.
However, it can do substituting parameters in the query:

```ruby
MDX_QUERY = 'SET [~ROWS_Date] AS {[DateTime].[Date].[Date].[%DATE%]}'

Olap::View.request MDX_QUERY, {'%DATE%' => '20150530'}
```

### Render Google Chart by MDX
At the moment only available `:table` and `:piechart` charts.

Insert helper menthod to `erb` file: 
```ruby
<%= olap_view_chart_by_mdx :table, 
    'SET [~ROWS_Date] AS {[DateTime].[Date].[Date].[%DATE%]}', 
    {'%DATE%' => '20150530'} %>
```

### Use one MDX to many Charts

```ruby
<% xmla = Olap::View.request 'SET [~ROWS_Date] AS {[DateTime].[Date].[Date].[%DATE%]}', 
    {'%DATE%' => '20150530'} %>
<div>
  <h1>PieChart</h1> 
  <%= olap_view_chart_by_xmla :piechart, xmla %>
</div>
<div>
  <h1>Table</h1>
  <%= olap_view_chart_by_xmla :table, xmla %>
</div>
```

### Available parameters
In `olap_view_chart_by_mdx` and `olap_view_chart_by_xmla` following properties are available:

```ruby
  <%= olap_view_chart_by_xmla :table, xmla, properties %> 
```

`total: true` show total string in table chart

`rowspan: true` unites the cells with the same data from the dimenssions in table chart

`function: "text on JS"` execute ani js code into chart template

`dimention: "Source Name"` aggregate xmla data by dimesion
 
`measures: "[Measures].[Click]"` remove measure from xmla data
 
`options: {}` Google Charts draw options




## Contributing

1. Fork it ( https://github.com/Wondersoft/olap-view/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
