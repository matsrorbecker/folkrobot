$(function() {
    $('#municipality').focus(function() {
        var field = $(this);
        if (field.val() == field.attr('value'))
            field.val('');
    });
});