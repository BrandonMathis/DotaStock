$ ->
  if sort == 'DESC'
    sorted_heroes = _.sortBy(heroes, (hero) -> -hero['usage'])
  else if sort == 'ASC'
    sorted_heroes = _.sortBy(heroes, (hero) -> hero['usage'])

  hero_usage = _.map(sorted_heroes, (hero) -> hero['usage'])
  hero_names = _.map(sorted_heroes, (hero) -> hero['name'])

  total_matches = 0
  _.each(hero_usage, (usage) ->
    total_matches += parseInt(usage)
  )

  container_height = hero_usage.length * 20
  container_width = 1000

  x = d3.scale.linear()
    .domain([0, d3.max(hero_usage)])
    .range([0,container_width - 10])

  y = d3.scale.linear()
    .domain([0, hero_usage.length])
    .range([0, container_height])

  chart = d3.select("body").append("svg")
    .attr("class", "chart")
    .attr("width", container_width)
    .attr("height", container_height + 20)
    .append('g')
    .attr('transform', 'translate(25,15)')

  chart.selectAll('line')
    .data(x.ticks(10))
    .enter().append('line')
    .attr('x1', x)
    .attr('x2', x)
    .attr('y1', 0)
    .attr('y2', container_height)
    .style('stroke', '#ccc')

  chart.selectAll("rect")
    .data(hero_usage)
    .enter().append("rect")
    .attr('y', (d, i) -> y(i))
    .attr("width", x)
    .attr("height", 20)

  chart.selectAll('text')
    .data(hero_names)
    .enter().append('text')
    .attr('x', 10)
    .attr('y', (d, i) -> y(i))
    .attr('dx',  (d) -> x(d.magnitude) - 5)
    .attr('dy', 20 - 5)
    .attr('text-anchor', 'start')
    .text(String)

  chart.selectAll('text.usage')
    .data(hero_usage)
    .enter().append('text')
    .attr('class', 'usage')
    .attr('x', -3)
    .attr('y', (d, i) -> y(i))
    .attr('dx',  (d) -> x(d.magnitude) - 5)
    .attr('dy', 20 - 5)
    .attr('text-anchor', 'end')
    .text(String)

  chart.selectAll('.rule')
    .data(x.ticks(10))
    .enter().append('text')
    .attr('class', 'rule')
    .attr('x', x)
    .attr('y', 0)
    .attr('dy', -3)
    .attr('text-anchor', 'middle')
    .text(String)

  chart.append('line')
    .attr('y1', 0)
    .attr('y2', container_height)
    .style('stroke', '#000')
