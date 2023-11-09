$(document).ready(() => {
    const stateSelect = $('#actionmap-event-state');
    const countySelect = $('#actionmap-event-county');
    stateSelect.change(() => {
        const stateSymbol = stateSelect.children('option:selected').val();
        if (stateSymbol === '') {
            countySelect.prop('disabled', true);
            return;
        }

        countySelect.prop('disabled', false);
        $.getJSON({
            url: `/ajax/state/${stateSymbol}`,
        }).done((countiesArray) => {
            countySelect.empty();
            countySelect.append(
                '<option value="" selected> County it will be held in... </option>',
            );
            $.each(countiesArray, (_index, county) => {
                countySelect.append(
                    `<option value="${county.id}"> ${county.name} </option>`,
                );
            });
        });
    });
});
