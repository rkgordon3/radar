$(function(){

validate = {


  

  staff: function(event) {
    var fields = $("div.field input");
    var boxes = $('#staff_org_');
    var empty_fields = 0;
    var checked_count = 0;
    var password_ok = false;
    update_password =  function() {
      return $("#update_password") == undefined || $("#update_password").prop('checked');
    };

    for (i = 0; i < fields.size() - 2; i++) {
      if ( !update_password()) {
        if (fields[i] == $("#staff_password") ||
          fields[i] == $("#staff_password_confirmation")) {
          continue;
        }
      }    
      if(fields[i].value == "") {
        empty_fields++;
        // This breaks
        //$("label[for=" + fields[i].id + "]").get(1).css({ display:'block', fontSize:'10px', color:'#aa0000'  } );
      }

    }
    alert("perform validation"); 

    event.preventDefault();
  }

}

$("#staff_form").submit( function(event) {
  alert("submit");
   validate.staff(event);
});


});
