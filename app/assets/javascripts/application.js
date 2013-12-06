//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require autocomplete-rails
//= require_tree .
function plusMinusToggle(divID,imgID) {

    //$(divID).toggle();
    var state = document.getElementById(divID).style.display;
    if (state == 'block') {
        document.getElementById(divID).style.display = 'none';
        document[imgID].src = '/assets/add_icon.gif';
    } else {
        document.getElementById(divID).style.display = 'block';
        document[imgID].src = '/assets/minus_icon.gif';
    }
}