var margin = {top: 20, right: 20, bottom: 30, left: 40},
    width = 600,
    height = 300;

var x = d3.scale.ordinal()
    .rangeRoundBands([0, width], .1);

var y = d3.scale.linear()
    .range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .ticks(10, "%");
    



//!!!!!!!!!!!!!!!!!!!!!!change the background color here !!!!!!!!!!!!!!!!!!!
var somediv = d3.select("p").append("div")
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



var svg = somediv.append("svg")
    .attr("width", width)
    .attr("height", height + margin.top + margin.bottom)
    .attr("style", "margin-left:160px; background: white;")
    .attr("style", "display:inline-block")
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");




//!!!!!!!!!!!!!!!!!!!!!!change the data source!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
d3.tsv("./data/winner.tsv", type, function(error, data) {
  if (error) throw error;
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!




  x.domain(data.map(function(d) { return d.letter; }));
  y.domain([0, d3.max(data, function(d) { return d.frequency; })]);

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Frequency");

  svg.selectAll(".bar")
      .data(data)
    .enter().append("rect")
      .attr("class", "bar")
      .attr("x", function(d) { return x(d.letter); })
      .attr("width", x.rangeBand())
      .attr("y", function(d) { return y(d.frequency); })
      .attr("height", function(d) { return height - y(d.frequency); });
});

function type(d) {
  d.frequency = +d.frequency;
  return d;
}

