$(function(){$("div#ltoc").hover(expandTOC,	function(){$(this).stop(true,false).animate({width:175},{"duration":"fast","easing":"swing"});});});
$(document).ready(function(){$("div#ltoc").css({overflow:"hidden"});$("a[rel='cbgroup']").colorbox({transition:"elastic", speed:"700"});});

function getContentWidth(obj) {
	var cWidth, cObj, width = 0;
	for (var i=0; i<obj.childNodes.length; i++){
		cObj = obj.childNodes[i];
		cWidth = 0;
		if (cObj.nodeName=="TABLE"){cWidth = cObj.clientWidth;}
		else if (cObj.nodeName=="DIV"){cWidth = getContentWidth(cObj);}
		if (cWidth > width) {width = cWidth}
	}
	return width;
}

function expandTOC(){
	var contentWidth = getContentWidth(document.getElementById("ltoc"));
	if(contentWidth>171){$(this).stop(true,false).css({zIndex:"99",position:"relative",overflow:"hidden"}).animate({width:contentWidth+"px"},{"duration":"fast","easing":"swing"});}
}


/* Function to hide/display a block object                                                       */
function fadeDIV(maintext, descr){
	var mtext = document.getElementById(maintext);
	var des = document.getElementById(descr);
	
	if(mtext.style.display == 'none'){
		des.style.display = 'none';
		//$(maintext).appear();
		//$(maintext).appear();
		mtext.style.display = 'block';
	}
	else{
		//Effect.SwitchOff(maintext);
		mtext.style.display = 'none';
		des.style.display = 'block';
		//$(descr).appear({ duration: 1.0 });
		}
}



