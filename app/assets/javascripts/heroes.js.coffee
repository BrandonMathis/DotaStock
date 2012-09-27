$ ->
  container_height = hero_usage.length * 20
  x = d3.scale.linear()
    .domain([0, d3.max(hero_usage)])
    .range([0,1000])

  y = d3.scale.ordinal()
    .domain(hero_usage)
    .rangeBands([0, container_height])

  chart = d3.select("body").append("svg")
    .attr("class", "chart")
    .attr("width", 1000)
    .attr("height", container_height)

  chart.selectAll("rect")
    .data(hero_usage)
    .enter().append("rect")
    .attr('y', y)
    .attr("width", x)
    .attr("height", y.rangeBand())

  chart.selectAll('text')
    .data(hero_usage)
    .enter().append('text')
    .attr('x', x)
    .attr('y', (d) -> y(d) + y.rangeBand() /2)
    .attr('dx',  -3)
    .attr('dy', '.35em')
    .attr('text-anchor', 'end')
    .text(String)
