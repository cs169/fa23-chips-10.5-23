const d3 = require('d3');
const stateMapUtils = require('./state_map_utils');

$(document).ready(() => {
    const stateMap = new stateMapUtils.Map();
    const countyFipsCode = stateMap.infoContainer.attr('county-std-fips-code');
    d3.json(stateMap.topojsonUrl).then((topology) => {
        const mapAssets = stateMapUtils.parseTopojson(stateMap, topology);
        stateMap.svgElement.selectAll('path')
            .data(mapAssets.geojson.features)
            .enter()
            .append('path')
            .attr('class', 'actionmap-view-region')
            .attr('d', mapAssets.path)
            .attr('style', (d) => {
                if (d.properties.COUNTYFP === countyFipsCode) {
                    return 'fill: #2780E3;';
                }
                return '';
            })
            .attr('data-county-name', (d) => stateMap.counties[d.properties.COUNTYFP].name)
            .attr('data-county-fips-code', (d) => d.properties.COUNTYFP);

        // We dont want to enable clicking in the county view.
        // stateMapUtils.setupEventHandlers(stateMap);
    });
});
