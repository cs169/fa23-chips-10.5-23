const d3 = require('d3');
const stateMapUtils = require('./state_map_utils');

require('../stylesheets/map.scss');

$(document).ready(() => {
    const stateMap = new stateMapUtils.Map();
    d3.json(stateMap.topojsonUrl).then((topology) => {
        const mapAssets = stateMapUtils.parseTopojson(stateMap, topology);
        stateMap.svgElement.selectAll('path')
            .data(mapAssets.geojson.features)
            .enter()
            .append('path')
            .attr('class', 'actionmap-view-region')
            .attr('d', mapAssets.path)
            .attr('data-county-name', (d) => stateMap.counties[d.properties.COUNTYFP].name)
            .attr('data-county-fips-code', (d) => d.properties.COUNTYFP);

        stateMapUtils.setupEventHandlers(stateMap);
    });
});
