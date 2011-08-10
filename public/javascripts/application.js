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

			


function hideDiv(divID){
			document.getElementById(divID).setAttribute("style", "display:none");
}
function showDiv(divID){
			document.getElementById(divID).setAttribute("style", "display:block");
}
function displayBuilding(spanID,building){
	document.getElementById(spanID).innerHTML=building;
}

Ajax.Responders.register({
  onCreate: function() {
    if($('busy') && Ajax.activeRequestCount>0)
      Effect.Appear('busy',{duration:0.5,queue:'end'});
  },
  onComplete: function() {
    if($('busy') && Ajax.activeRequestCount==0)
      Effect.Fade('busy',{duration:0.5,queue:'end'});
  }
});