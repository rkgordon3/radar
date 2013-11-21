function reset_field(input) {
       $("label[for=" + input.id + "]").get(1).css({ display:'none' });
	   if ($("label[for=" + input.id + "]").get( != undefined) {
	     $("label[for=" + input.id + "]").get(2).css({ display:'none' });
	   }
}

function reset_password_fields(input) {
  if (!input.checked) {
	$("#staff_password").val() = "";
	$("#staff_password_confirmation").val()  = "";
  }
  reset_field($("#staff_password"));
  reset_field($("#staff_password_confirmation"));
}

function staff_form_validate(e) { 


  for (i = 0; i < fields.size() - 2; i++) {
       if ( !update_password()) {
	     if (fields[i] == $("#staff_password") ||
		     fields[i] == $("#staff_password_confirmation")) {
			   continue;
		    }
      }	   
      if(fields[i].val() == "") {
            empty_fields++;
            $("label[for=" + fields[i].id + "]").get(1).css({ display:'block', fontSize:'10px', color:'#aa0000'  } );
      }
  }

  
  
  for (i = 0; i < boxes.size(); i++) {
       if (boxes[i].checked) {
         checked_count++;
       }
  }

  if ( update_password())  {
    if ( $("#staff_password").val() != $("#staff_password_confirmation").val()) {;
	  $("label[for=staff_password_confirmation]").get(2).css({ display:'block', fontSize:'10px', color:'#aa0000' });
    } else if ($("#staff_password").val() != "") {
      password_ok = true;
      $("label[for=staff_password_confirmation]").get(2).css({ display:'none' });
    }
  } else {
     password_ok = true;
  }

  if (checked_count < 1) {
       $('label[for="staff_org_"]').get(0).css({ display:'block', fontSize:'10px', color:'#aa0000'  } );
  }

  if (checked_count < 1 || empty_fields > 0 || password_ok == false) {
       e.stop();
  }
}
$(function() {
alert("staff validate loaded");
});
