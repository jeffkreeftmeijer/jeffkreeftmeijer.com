function send(location) {
  $('head').append($('<script type="text/javascript" src="http://jeffkreeftmeijer.com:8080/' + location + '" async="true"></script>'));
}

function ping() {
  send('ping?id=' + readcookie('tracker'));
}

function readcookie(k) {
  var c=""+document.cookie;
  var ind=c.indexOf(k);
  if (ind==-1 || k==""){
    return "";
  }
  var ind1=c.indexOf(';',ind);
  if (ind1==-1){
    ind1=c.length;
  }
  return unescape(c.substring(ind+k.length+1,ind1));
}

function createcookie(k,v,days){
  var exp='';
  var expires = new Date();
  expires.setDate(expires.getDate() + 100);
  exp = expires.toGMTString();

  cookieval = k + '=' + v + '; ' + 'expires=' + exp + ';' + 'path=/'+';';
  document.cookie = cookieval;
}

function randomstring() {
  var chars = "0123456789abcdefghijklmnopqrstuvwxyz";
  var s = '';
  for (var i = 0; i < 32; i++) {
    var rnum = Math.floor(Math.random() * chars.length);
    s += chars.substring(rnum, rnum + 1);
  }
  return s;
}

var _c=readcookie('tracker');
if(!_c){
  _c=randomstring();
  createcookie('tracker', _c);
}

query = 'track?id=' + readcookie('tracker') +
'&language=' + navigator.language +
'&userAgent=' + navigator.userAgent +
'&location=' +  location.pathname

if(document.referrer.split('/')[2] != location.hostname) {
  query += '&referrer=' + document.referrer
}

send(query);
