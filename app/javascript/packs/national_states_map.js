const d3 = require('d3');
const topojson = require('topojson');

const mapUtils = require('./map_utils');

require('../stylesheets/map.scss');

$(document).ready(() => {
    function Map() {
        const map = Object.create(Map.prototype);
        map.width = 950;
        map.height = 600;
        map.svgElement = d3.select('#actionmap-national-view')
            .attr('width', map.width)
            .attr('height', map.height)
            .attr('preserveAspectRatio', 'xMinYMin meet');

        map.infoContainer = $('#actionmap-info-container');
        map.topojsonUrl = `${window.location.origin}${map.infoContainer.attr('data-states-topojson-file')}`;
        map.objectsKey = 'cb_2018_us_state_500k';
        return map;
    }

    const nationalMap = new Map();
    d3.json(nationalMap.topojsonUrl).then((topology) => { /** Topology is a topojson object */
        /** Convert topojson to geojson */
        const geojson = topojson.feature(
            topology,
            topology.objects[nationalMap.objectsKey],
        );
        const projection = d3.geoAlbersUsa()
            .fitExtent(
                [
                    [20, 20], /** Padding of 20px on both x and y axis */
                    [nationalMap.width, nationalMap.height],
                ],
                geojson,
            );
        const path = d3.geoPath()
            .projection(projection);

        nationalMap.svgElement.selectAll('path')
            .data(geojson.features)
            .enter()
            .append('path')
            .attr('class', 'actionmap-view-region')
            .attr('d', path)
            .attr('data-state-name', (d) => d.properties.NAME)
            .attr('data-state-fips-code', (d) => d.properties.STATEFP)
            .attr('data-state-symbol', (d) => d.properties.STUSPS);

        const targets = $('.actionmap-view-region');
        const hoverHtmlProvider = (elem) => {
            const stateName = elem.attr('data-state-name');
            const stateSymbol = elem.attr('data-state-symbol');
            return `${stateName}, ${stateSymbol}`;
        };
        const clickCallback = (elem) => {
            const stateSymbol = elem.attr('data-state-symbol');
            window.location.href = `/state/${stateSymbol}`;
        };
        mapUtils.handleMapMouseEvents(targets, hoverHtmlProvider, clickCallback);
    });
});
