$ ->
  chart = d3.select("body").append("div").attr("class", "chart")

  x = d3.scale.linear()
    .domain([0, d3.max(hero_usage)])
    .range(['0px', '1000px'])

  chart.selectAll("div")
    .data(hero_usage)
    .enter()
    .append("div")
    .style("width", x)
    .style("height", "20px")
    .text((d)-> d)
