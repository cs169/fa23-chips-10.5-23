const filterUtils = require('./state_county_filter_util');

$(document).ready(() => {
    filterUtils.filterByChangedCallback(
        $('input:radio[name="filter-by"]:checked').val(),
        $('#actionmap-events-filter-county'),
    );

    $('input:radio[name="filter-by"]').change((e) => {
        filterUtils.filterByChangedCallback(
            $(e.currentTarget).val(),
            $('#actionmap-events-filter-county'),
        );
    });

    $('#actionmap-events-filter-state').change((e) => {
        const filterBy = $('input:radio[name="filter-by"]:checked').val();
        const stateSelectElem = $(e.currentTarget);
        const countySelectElem = $('#actionmap-events-filter-county');
        const submitButtonElem = $('#actionmap-events-filter-submit');

        filterUtils.stateChangedCallback({
            filterBy,
            stateSymbol: stateSelectElem.children('option:selected').val(),
            countySelectElem,
            submitButtonElem,
        });
        const stateSymbol = stateSelectElem.children('option:selected').val();
        const countyCode = countySelectElem.children('option:selected').val();

        filterUtils.toggleSubmitButton({
            filterBy,
            stateSymbol,
            countyCode,
            submitButtonElem,
        });
    });

    $('#actionmap-events-filter-county').change((e) => {
        const filterBy = $('input:radio[name="filter-by"]:checked').val();
        const stateSymbol = $('#actionmap-events-filter-state').children('option:selected').val();
        const countyCode = $(e.currentTarget).children('option:selected').val();
        const submitButtonElem = $('#actionmap-events-filter-submit');

        filterUtils.toggleSubmitButton({
            filterBy,
            stateSymbol,
            countyCode,
            submitButtonElem,
        });
    });
});
