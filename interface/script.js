$(document).ready(function(){

  $(function(){
    var client = mqtt.connect('userconnection', {
      clientId: 'd905e6b1'
    });

    client.on('connect', function(){
      console.log('client has connected!');
    });
    client.subscribe('/example');

    client.on('message', function(topic, message) {
      console.log('new message:', topic, message.toString());
    });
    $('#answer').on('keyup',function(){
      var an=$(this).val();
      var index=an.length;
      var letter=an.charAt(index-1);
      client.publish('/example',letter);
    });

    $('#reloadbutton').on('click',function(){
      $('#answer').val("");
      $('h1').text("What's your name?");
      counter=0;
      client.publish('/example',"1111");
    });

  });
var questions=["What's your favorite color?", "What's your age?", "What's your pets name?", "What's your email address?", "How many cigarettes do you smoke?", "What's your favorite city?", "What's the last message you sent?", "Who is the last person you messaged to?", "What languages do you speak?", "What's your phone number?","Thank you for giving us your data.\n In this case you can rest asure that we won't misuse it, but keep in mind that others could."];
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
