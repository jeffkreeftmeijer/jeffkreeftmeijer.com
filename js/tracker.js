Tracker = function(hostname) {
  tracker = this;

  tracker.hostname = hostname || window.location.hostname;
  tracker.server = 'http://jeffkreeftmeijer.com:8080/';
};

Tracker.prototype = {
  track: function() {
    tracker.send('track' + tracker.query({
      id: tracker.cookie_id(),
      hostname: tracker.hostname,
      location: location.pathname,
      referrer: (document.referrer.split('/')[2] != location.hostname) ? document.referrer : ''
    }));
  },

  ping: function(){
    tracker.send('ping' + tracker.query({
      id: tracker.cookie_id(),
      hostname: tracker.hostname
    }));
  },

  send: function(location) {
    script=document.createElement('script');
    script.type = 'text/javascript';
    script.src = tracker.server + location;
    script.async = true;

    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(script);
  },

  query: function(data) {
    query = '?';
    for(param in data) {
      if(query != '?'){
        query += '&';
      }
      query += [param, data[param]].join('=');
    }
    return query;
  },

  cookie_id: function(){
    cookie = tracker.readcookie('tracker');
    if (!cookie) {
      cookie = tracker.randomstring();
      tracker.createcookie('tracker', cookie, 10*1000)
    }
    return cookie;
  },

  readcookie: function(k) {
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
  },

  createcookie: function(k,v,days) {
    var exp='';
    if(days>0){
      var expires = new Date();
      expires.setDate(expires.getDate() + days);
      exp = expires.toGMTString();
    }
    cookieval = k + '=' + v + '; ' + 'expires=' + exp + ';' + 'path=/'+';';
    document.cookie = cookieval;
  },

  randomstring: function() {
    var chars = "0123456789abcdefghijklmnopqrstuvwxyz";
    var s = '';
    for (var i = 0; i < 32; i++) {
      var rnum = Math.floor(Math.random() * chars.length);
      s += chars.substring(rnum, rnum + 1);
    }
    return s;
  }
};
