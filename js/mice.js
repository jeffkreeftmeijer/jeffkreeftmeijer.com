function ratelimit(fn, ms) {
  var last = (new Date()).getTime();
  return (function() {
    var now = (new Date()).getTime();
    if (now - last > ms) {
      last = now;
      fn.apply(null, arguments);
    }
  });
}

function move(mouse){
  if(disabled == false){
    if($('#mouse_'+mouse['id']).length == 0) {
      $('body').append('<div class="mouse" id="mouse_'+mouse['id']+'"/>');
    }
    $('#mouse_'+mouse['id']).css({
      'left' : (($(window).width() - mouse['w']) / 2 + mouse['x']) + 'px',
      'top' : mouse['y'] + 'px'
    })  
  }
}

$(document).ready(function(){
  $('#mouse_toggle a').toggle(function(){
    $('.mouse').hide();
    disabled = true;
    $(this).html('enable');
  }, function(){
    $('.mouse').show();
    disabled = false;
    $(this).html('disable');
  })
})

$(document).mousemove(
  ratelimit(function(e){
    if (conn) {
      conn.send(JSON.stringify({
        'action': 'move',
        'x': e.pageX,
        'y': e.pageY,
        'w': $(window).width(),
        'h': $(window).height()
      }));
    }
  }, 40)
);

var disabled = false;
var conn;
var connect = function() {
  if (window["WebSocket"]) {
    $('#mouse_toggle').show();
    $('#no_web_sockets').hide();
    conn = new WebSocket("ws://jeffkreeftmeijer.com:8000/test");
    conn.onmessage = function(evt) {
      data = JSON.parse(evt.data);
      if(data['action'] == 'close'){
        $('#mouse_'+data['id']).remove();
      } else if(data['action'] == 'move'){
        move(data);
      };
    };
  }
};
window.onload = connect;