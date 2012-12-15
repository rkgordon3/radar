// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

image1 = new Image();
image1.src = "/images/add_icon.gif";

image2 = new Image();
image2.src = "/images/minus_icon.gif";



function plusMinusToggle(divID,imgID) {

    var state = document.getElementById(divID).style.display;
    if (state == 'block') {
        document.getElementById(divID).style.display = 'none';
        document[imgID].src = '/images/add_icon.gif';
    } else {
        document.getElementById(divID).style.display = 'block';
        document[imgID].src = '/images/minus_icon.gif';
    }
}

function doubleDivToggle(divID1,divID2) {

    var state = document.getElementById(divID1).style.display;
    if (state == 'none') {
        document.getElementById(divID1).style.display = 'block';
    } else {
        document.getElementById(divID1).style.display = 'none';
    }
    
    state = document.getElementById(divID2).style.display;
    if (state == 'none') {
        document.getElementById(divID2).style.display = 'block';
    } else {
        document.getElementById(divID2).style.display = 'none';
    }
}

function reset_box(input) {
  if (input.checked) {
       $$("label[for=" + input.id + "]")[0].setStyle({ display:'none' }); 
  }
}

function hideDiv(divID){
    document.getElementById(divID).setAttribute("style", "display:none");
}
function showDiv(divID){
    document.getElementById(divID).setAttribute("style", "display:block");
}
function populateIphoneMenu(spanID,building, building_id){

    if (building_id != null) {
		document.getElementById(spanID+'_id').value = building_id
	}
    document.getElementById(spanID).innerHTML=building;
}

Ajax.Responders.register({
    onCreate: function() {
        if($('busy') && Ajax.activeRequestCount>0)
            Effect.Appear('busy',{
                duration:0.5,
                queue:'end'
            });
    },
    onComplete: function() {
        if($('busy') && Ajax.activeRequestCount==0)
            Effect.Fade('busy',{
                duration:0.5,
                queue:'end'
            });
    }
});


function type(obj){
    return Object.prototype.toString.call(obj).match(/^\[object (.*)\]$/)[1]
}


function reset_field(input) {
  if (input.value != "") {
       $$("label[for=" + input.id + "]")[1].setStyle({ display:'none' });
  }
}

function staff_form_validate(e) { 
  var fields = $$('div.field input');
  var boxes = $$('#staff_org_');
  var empty_fields = 0;
  var checked_count = 0;
  var password_checked = false;

  for (i = 0; i < fields.size() - 2; i++) {
       if(fields[i].value == "") {
            empty_fields++;
            $$("label[for=" + fields[i].id + "]")[1].setStyle({ display:'block', fontSize:'10px', color:'#aa0000'  } );
       }
  }

  if ( $("staff_password").value != $("staff_password_confirmation").value) {;
	  $$("label[for=staff_password_confirmation]")[2].setStyle({ display:'block', fontSize:'10px', color:'#aa0000' });
  } else if ($("staff_password").value != "") {
      password_checked = true;
      $$("label[for=staff_password_confirmation]")[2].setStyle({ display:'none' });
  }
  
  for (i = 0; i < boxes.size(); i++) {
       if (boxes[i].checked) {
         checked_count++;
       }
  }

  if (checked_count < 1) {
       $$('label[for="staff_org_"]')[0].setStyle({ display:'block', fontSize:'10px', color:'#aa0000'  } );
  }

  if (checked_count < 1 || empty_fields > 0 || password_checked == false) {
       e.stop();
  }
}
Event.observe(window, 'load', function() {
   Event.observe('staff_form', 'submit', staff_form_validate);
});


