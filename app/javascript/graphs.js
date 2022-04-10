// D3 charts
import * as d3 from "d3";
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}


// Copyright 2021 Observable, Inc.
// Released under the ISC license.
// https://observablehq.com/@d3/pie-chart
function PieChart(data, {
  name = ([x]) => x,  // given d in data, returns the (ordinal) label
  value = ([, y]) => y, // given d in data, returns the (quantitative) value
  title, // given d in data, returns the title text
  width = 640, // outer width, in pixels
  height = 400, // outer height, in pixels
  innerRadius = 0, // inner radius of pie, in pixels (non-zero for donut)
  outerRadius = Math.min(width, height) / 2, // outer radius of pie, in pixels
  labelRadius = (innerRadius * 0.2 + outerRadius * 0.8), // center radius of labels
  format = ",", // a format specifier for values (in the label)
  names, // array of names (the domain of the color scale)
  colors, // array of colors for names
  stroke = innerRadius > 0 ? "none" : "white", // stroke separating widths
  strokeWidth = 1, // width of stroke separating wedges
  strokeLinejoin = "round", // line join of stroke separating wedges
  padAngle = stroke === "none" ? 1 / outerRadius : 0, // angular separation between wedges
} = {}) {
  // Compute values.
  const N = d3.map(data, name);
  const V = d3.map(data, value);
  const I = d3.range(N.length).filter(i => !isNaN(V[i]));

  // Unique the names.
  if (names === undefined) names = N;
  names = new d3.InternSet(names);

  // Chose a default color scheme based on cardinality.
  if (colors === undefined) colors = d3.schemeSpectral[names.size];
  if (colors === undefined) colors = d3.quantize(t => d3.interpolateSpectral(t * 0.8 + 0.1), names.size);

  // Construct scales.
  const color = d3.scaleOrdinal(names, colors);

  // Compute titles.
  if (title === undefined) {
    const formatValue = d3.format(format);
    title = i => `${N[i]}\n${formatValue(V[i])}`;
  } else {
    const O = d3.map(data, d => d);
    const T = title;
    title = i => T(O[i], i, data);
  }

  // Construct arcs.
  const arcs = d3.pie().padAngle(padAngle).sort(null).value(i => V[i])(I);
  const arc = d3.arc().innerRadius(innerRadius).outerRadius(outerRadius);
  const arcLabel = d3.arc().innerRadius(labelRadius).outerRadius(labelRadius);
  
  const svg = d3.create("svg")
      .attr("width", width)
      .attr("height", height)
      .attr("viewBox", [-width / 2, -height / 2, width, height])
      .attr("style", "max-width: 100%; height: auto; height: intrinsic;");

  svg.append("g")
      .attr("stroke", stroke)
      .attr("stroke-width", strokeWidth)
      .attr("stroke-linejoin", strokeLinejoin)
    .selectAll("path")
    .data(arcs)
    .join("path")
      .attr("fill", d => color(N[d.data]))
      .attr("d", arc)
    .append("title")
      .text(d => title(d.data));

  svg.append("g")
      .attr("font-family", "sans-serif")
      .attr("font-size", 10)
      .attr("text-anchor", "middle")
    .selectAll("text")
    .data(arcs)
    .join("text")
      .attr("transform", d => `translate(${arcLabel.centroid(d)})`)
    .selectAll("tspan")
    .data(d => {
      const lines = `${title(d.data)}`.split(/\n/);
      return (d.endAngle - d.startAngle) > 0.25 ? lines : lines.slice(0, 1);
    })
    .join("tspan")
      .attr("x", 0)
      .attr("y", (_, i) => `${i * 1.1}em`)
      .attr("font-weight", (_, i) => i ? null : "bold")
      .text(d => d);

  return Object.assign(svg.node(), {scales: {color}});
}

// Copyright 2021 Observable, Inc.
// Released under the ISC license.
// https://observablehq.com/@d3/bar-chart
function BarChart(data, {
  x = (d, i) => i, // given d in data, returns the (ordinal) x-value
  y = d => d, // given d in data, returns the (quantitative) y-value
  title, // given d in data, returns the title text
  marginTop = 20, // the top margin, in pixels
  marginRight = 0, // the right margin, in pixels
  marginBottom = 30, // the bottom margin, in pixels
  marginLeft = 40, // the left margin, in pixels
  width = 640, // the outer width of the chart, in pixels
  height = 400, // the outer height of the chart, in pixels
  xDomain, // an array of (ordinal) x-values
  xRange = [marginLeft, width - marginRight], // [left, right]
  yType = d3.scaleLinear, // y-scale type
  yDomain, // [ymin, ymax]
  yRange = [height - marginBottom, marginTop], // [bottom, top]
  xPadding = 0.1, // amount of x-range to reserve to separate bars
  yFormat, // a format specifier string for the y-axis
  yLabel, // a label for the y-axis
  color = "currentColor" // bar fill color
} = {}) {
  // Compute values.
  const X = d3.map(data, x);
  const Y = d3.map(data, y);

  // Compute default domains, and unique the x-domain.
  if (xDomain === undefined) xDomain = X;
  if (yDomain === undefined) yDomain = [0, d3.max(Y)];
  xDomain = new d3.InternSet(xDomain);

  // Omit any data not present in the x-domain.
  const I = d3.range(X.length).filter(i => xDomain.has(X[i]));

  // Construct scales, axes, and formats.
  const xScale = d3.scaleBand(xDomain, xRange).padding(xPadding);
  const yScale = yType(yDomain, yRange);
  const xAxis = d3.axisBottom(xScale).tickSizeOuter(0);
  const yAxis = d3.axisLeft(yScale).ticks(height / 40, yFormat);

  // Compute titles.
  if (title === undefined) {
    const formatValue = yScale.tickFormat(100, yFormat);
    title = i => `${X[i]}\n${formatValue(Y[i])}`;
  } else {
    const O = d3.map(data, d => d);
    const T = title;
    title = i => T(O[i], i, data);
  }

  const svg = d3.create("svg")
      .attr("width", width)
      .attr("height", height)
      .attr("viewBox", [0, 0, width, height])
      .attr("style", "max-width: 100%; height: auto; height: intrinsic;");

  svg.append("g")
      .attr("transform", `translate(${marginLeft},0)`)
      .call(yAxis)
      .call(g => g.select(".domain").remove())
      .call(g => g.selectAll(".tick line").clone()
          .attr("x2", width - marginLeft - marginRight)
          .attr("stroke-opacity", 0.1))
      .call(g => g.append("text")
          .attr("x", -marginLeft)
          .attr("y", 10)
          .attr("fill", "currentColor")
          .attr("text-anchor", "start")
          .text(yLabel));

  const bar = svg.append("g")
      .attr("fill", color)
    .selectAll("rect")
    .data(I)
    .join("rect")
      .attr("x", function(i) {
        return xScale.bandwidth() > width/10 ? xScale(X[i]) + (xScale.bandwidth()/2) - (width/20) : xScale(X[i])
      })
      .attr("y", i => yScale(Y[i]))
      .attr("height", i => yScale(0) - yScale(Y[i]))
      .attr("width", function(d) {
        return xScale.bandwidth() > width/10 ? width/10 : xScale.bandwidth();
      })

  if (title) bar.append("title")
      .text(title);

  svg.append("g")
      .attr("transform", `translate(0,${height - marginBottom})`)
      .call(xAxis);

  return svg.node();
}


// form events
$(document).on('turbo:load', function() {


  $(document).on('change', '#graph-type-select', function() {

    var target = this.value

    $(".form_questions_option").addClass("form_hide")
  
    if(target == "Table") {
      $("#input_options").removeClass("form_hide")
    }
    else if (target == "Yes no beeswarm graph" || target == "Yes no bar graph") {
      $("#yes_no_options").removeClass("form_hide")
    }
    else {
      $("#multi_yes_no_options").removeClass("form_hide")
    }
  });
});

// load graphs
$(document).on('turbo:load', function() {

  $("#show_graphs").on('click', async function () {
    
    await sleep(50);
    while(!$("#ready").length) {
      await sleep(50);
    }
    
    console.log($(".poll_question_results").length)
    $(".poll_question_results").each(function (index) {

      let data_api = $(this).attr("data-path");

      let params = {
        graph_index: index,
        graph_type: $(this).attr("data-graph-type")
      }

      $.getJSON(data_api, params, function (data) {
      
        data = data["data"]

        // !REMOVE
        data[0]["value"] = 10
        console.log(data)

        if(params.graph_type != "Input") {

          if(params.graph_type != "Yes No") {
            console.log("why?!")
            $(".poll_question_results").eq(params.graph_index).append(BarChart(data,{
              x: d => d.label,
              y: d => d.value,
              width: 640, 
              height: 300,
              yFormat: 'r',
              color: 'steelblue',
              yLabel: 'votes'
            }));

          }
          else {
            console.log("why??")
            $(".poll_question_results").eq(params.graph_index).append(PieChart(data,{
              name: d => d.label,
              value: d => d.value,
              width: 640, 
              height: 300
            }));

          }

        } else {
          console.log("wtf??")
          data = ["Write short paragraphs and cover one topic per paragraph. Long paragraphs discourage users from even trying to understand your material. Short paragraphs are easier to read and understand. Writing experts recommend paragraphs of no more than 150 words in three to eight sentences.","Hello","Hello","Hello","Hello","Hello","Hello","Hello","Hello"]
          $(".poll_question_results").eq(params.graph_index).append(`<table class="table table-striped">
                                                            <thead>
                                                              <tr>
                                                                <th scope="col">#</th>
                                                                <th scope="col">Respondent</th>
                                                                <th scope="col">Response</th>
                                                              </tr>
                                                          </thead>
                                                          <tbody id="graph_` + params.graph_index + `">
                                                          </tbody>
                                                          </table>`)

          let table_row = "";
          for(let i=0; i < data.length; i++) {
            table_row = `<tr>
                          <th scope="row">`+ i +`</th>
                          <td></td>
                          <td>`+data[i]+`</td>
                        </tr>`

            let table_id = "#graph_" + params.graph_index
            $(table_id).append(table_row);
          }
        }
      
      });
    });


  });
});