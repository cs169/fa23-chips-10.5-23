exports.filterByChangedCallback = (filterBy, countySelectElem) => {
    switch (filterBy) {
    case 'state-only':
        countySelectElem.addClass('d-none');
        break;
    case 'county':
        countySelectElem.removeClass('d-none');
        break;
    default:
        throw new Error(`Unknown filter-by value ${filterBy}`);
    }
};

/**
 * @param args is an object with the following fields:
 *      filterBy - (string) eg. state-only.
 *      stateSymbol - (string) eg. CA.
 *      countySelectElem - jQuery element
 *      submitButtonElem - jQuery element
 */
exports.stateChangedCallback = (args) => {
    const flushOptions = () => {
        args.countySelectElem.empty();
        args.countySelectElem.append(
            '<option value="" selected> Select a county </option>',
        );
    };

    if (!args.stateSymbol || !args.stateSymbol.trim()) {
        flushOptions();
        return;
    }
    if (args.filterBy === 'state-only') {
        flushOptions();
        return;
    }

    $.getJSON({
        url: `/ajax/state/${args.stateSymbol}`,
    }).done((countiesArray) => {
        args.countySelectElem.prop('disabled', false);
        args.submitButtonElem.prop('disabled', true);
        flushOptions();
        $.each(countiesArray, (_index, county) => {
            args.countySelectElem.append(
                `<option value="${county.fips_code}"> ${county.name} </option>`,
            );
        });
    });
};

/**
 *
 * @param args is an object with the following fields:
 *      filterBy - (string) eg. state-only
 *      stateSybmol - (string) eg. CA
 *      county (string) eg. Alameda
 *      submitButtonElem - jQuery element
 */
exports.toggleSubmitButton = (args) => {
    const isValidState = !!args.stateSymbol;
    const isValidCounty = !!args.countyCode;
    switch (args.filterBy) {
    case 'state-only':
        args.submitButtonElem.prop('disabled', !isValidState);
        return;
    case 'county':
        args.submitButtonElem.prop('disabled', !isValidState || !isValidCounty);
        return;
    default:
        throw new Error(`unknown filter-by value ${args.filterBy}`);
    }
};
