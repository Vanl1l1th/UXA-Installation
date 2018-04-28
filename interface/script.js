var counter=0;
var laInput="g";
var laOutput="o";
var audio=0;
$(document).ready(function(){
var h=$("<h1>What's your name?</h1>");
var questions=["What's your age?", "What's your zip-code?", "What's your favorite city?", "Who is the last person you messaged to?", "What's your mother tongue?", "What's your phone number?","Thank you for giving us your data.\n In this case you can rest assure that we will not misuse it, but keep in mind that others could."];
  $(function(){
    var client = mqtt.connect('mqtt://d905e6b1:7cdec6cd7950ec48@broker.shiftr.io', {
      clientId: 'd905e6b1'
    });

    client.on('connect', function(){
      console.log('client has connected!');
    });
    client.subscribe('/kinect');
    client.subscribe('/audio');

    client.on('message', function(topic, message) {
      console.log('new message:', topic, message.toString());
    });
    $('#answer').on('keyup',function(e){
      var an=$(this).val();
      var index=an.length;
      var letter=an.charAt(index-1);
      if (e.keyCode == 13){
      $('h1').text(questions[counter]);
      if(counter==5){ var txt=$('#answer').val(); var char=txt.slice(0,1); txt=txt.slice(1,txt.length);
    char=char.toUpperCase(); txt=txt.toLowerCase(); laInput=char.concat(txt); console.log(laInput);
    }
      if(counter==6){var out= laOutput.toString(); client.publish('/kinect',out);}
      counter=counter+1;
      $('#answer').val("");}
      else{client.publish('/kinect',letter);}
    });

    $('#reloadbutton').on('click',function(){
      $('#answer').val("");
      h.remove();
      counter=0;
      audio=0;
      client.publish('/kinect',"1111");
      $('#start').show();
      $('#next').hide();
      $('#reloadbutton').hide();
    });

    $('#next').on('click',function(){
      $('h1').text(questions[counter]);
      if(counter==5){var txt=$('#answer').val(); var char=txt.slice(0,1); txt=txt.slice(1,txt.length);
      char=char.toUpperCase(); txt=txt.toLowerCase(); laInput=char.concat(txt); console.log(laInput);}
      if(counter==6){var out= laOutput.toString(); client.publish('/kinect',out);}
      counter=counter+1;
      audio++; var a= audio.toString();
      client.publish('/audio',a);
      $('#answer').val("");
    });

    $('#start').on('click',function(){
      $('body').prepend(h);
      $(h).text("What's your name?");
      $('#start').hide();
      audio++; var as=audio.toString();
      client.publish('/audio',as);
    });
  });


$('#answer').keypress(function(){
  $('#next').show();
  $('#reloadbutton').show();
});


});
var laObj;
var laCode;
var lc="de";
function setup(){
  noCanvas();
  loadJSON("https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20180427T191917Z.b59ba6b5ba9f5b04.e1e9303af86dd47b210a9d979dfef956b03b20ab&text=thank you for your data&lang=en-"+lc,gotData,'jsonp');
  loadJSON("https://translate.yandex.net/api/v1.5/tr.json/getLangs?key=trnsl.1.1.20180427T191917Z.b59ba6b5ba9f5b04.e1e9303af86dd47b210a9d979dfef956b03b20ab&ui=langs",gotData2,'jsonp');
}
function gotData(data){laOutput=data.text;}
function gotData2(data2){ laObj=data2.langs; laCode=Object.keys(laObj);}
function draw(){
  var index2=0;
  if(laInput.length>2){for(x in laObj){if(laObj[x]==laInput){lc=laCode[index2];
loadJSON("https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20180427T191917Z.b59ba6b5ba9f5b04.e1e9303af86dd47b210a9d979dfef956b03b20ab&text=thank you for your data&lang=en-"+lc,gotData,'jsonp');}
index2++;}
laInput="de";}
}
