$(document).ready(function(){

  $(function(){
    var client = mqtt.connect('mqtt://d905e6b1:7cdec6cd7950ec48@broker.shiftr.io', {
      clientId: 'd905e6b1'
    });

    client.on('connect', function(){
      console.log('client has connected!');
    });
    client.subscribe('/example');

    client.on('message', function(topic, message) {
      console.log('new message:', topic, message.toString());
    });
    $('#answer').on('keyup',function(e){
      var an=$(this).val();
      var index=an.length;
      var letter=an.charAt(index-1);
      if (e.keyCode == 13){$('h1').text(questions[counter]);
      counter=counter+1;
      $('#answer').val("");}
      else{client.publish('/example',letter);}

    });

    $('#reloadbutton').on('click',function(){
      $('#answer').val("");
      $('h1').text("What's your name?");
      counter=0;
      client.publish('/example',"1111");
    });

  });
var questions=["What's your age?", "What's your zip-code?", "What's your favorite city?", "Who is the last person you messaged to?", "What's your mother tongue?", "What's your phone number?","Thank you for giving us your data.\n In this case you can rest assure that we will not misuse it, but keep in mind that others could."];
var counter=0;
$('#answer').keypress(function(){
  $('#next').show();
  $('#reloadbutton').show();
})
$('#next').on('click',function(){
  $('h1').text(questions[counter]);
  counter=counter+1;
  $('#answer').val("");
});


});
