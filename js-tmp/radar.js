mage1 = new Image();
image1.src = "add_icon.gif";
image2 = new Image();
image2.src = "minus_icon.gif";



function plusMinusToggle(divID,imgID) {

    var state = document.getElementById(divID).style.display;
    if (state == 'block') {
        document.getElementById(divID).style.display = 'none';
        document[imgID].src = '/assets/add_icon.gif';
    } else {
        document.getElementById(divID).style.display = 'block';
        document[imgID].src = '/assets/minus_icon.gif';
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
//
// validation code for staff create has been moved to validate.js
//
