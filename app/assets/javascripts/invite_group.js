$(function() {
    $("#group_in_the_list").hide();
    $("#remove").hide();

    $("#add_group").click(add_group);
});

function add_group() {
    group_id = $("#group_id").val();
    group_desc = $("#group_id").find("option:selected").text();

    if (group_desc != "") {
        found = false
        $('#table_groups tbody tr').each(function() {
            if ( $(this).attr('id') == "row_" + group_id ) {
                alert($("#group_in_the_list").text());
                found = true;
            }
        });

        if (!found) {
            $('#table_groups > tbody:last').append(
                '<tr id="row_' + group_id + '"><td>' + group_desc + '<input type="hidden" name="groups[]" value="' + group_id + '" /></td><td><input type="button" class="m-btn red" id="group_id_' + group_id + '" onclick="remove_group(\'' + group_id + '\')" value="' + $("#remove").text() + '" /></td></tr>'
            );
        }
    }
}

function remove_group(id) {
    $("#row_" + id).remove();
}
