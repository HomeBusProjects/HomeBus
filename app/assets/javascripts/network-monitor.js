$(document).ready(function() {
    console.log('setting up broker');

    if(typeof monitor_params == 'undefined') {
	console.error('no monitor_params');
	return;
    }

    client = new Paho.Client(monitor_params['broker']['server'], monitor_params['broker']['port'], monitor_params['broker']['client_id']);

    client.onConnectionLost = onConnectionLost; 
    client.onMessageArrived = onMessageArrived;

    let options = {
	useSSL: true,
	userName: monitor_params['broker']['username'],
	password: monitor_params['broker']['password'],
	onSuccess: onConnect,
	onFailure: onConnectFail,
	reconnect: true
    };

    console.log('about to connect to broker');
    client.connect(options);

    // refresh the refresh token once per minute to keep the monitor alive
    setInterval(function () {
	$.ajax({
	    url: '/provision/refresh',
	    method: 'POST',
	    error: function(jqXHR, status, error) { console.error('refresh token refresh failed'); console.error(status); console.error(error); },
	    success: function(data) { console.log('got refresh_token'); console.log(data); monitor_params['refresh_token'] = data['refresh_token']; },
	    dataType: 'json',
	    headers: { 'Authorization': monitor_params['refresh_token'] }
	});
    }, 1000*60);
});

function onConnect() {
  console.log('broker connected');
  monitor_params['ddcs'].forEach(function(ddc) {
    client.subscribe('homebus/device/+/' + ddc);
      console.log('subscribed to ' + 'homebus/device/+/' + ddc);
  });

  monitor_params['endpoints'].forEach(function(endpoint) {
      client.subscribe(endpoint);
      console.log('subscribed to ' + endpoint);
  });
}

function onConnectionLost(responseObject) {
    if (responseObject.errorCode !== 0) {
        console.log("onConnectionLost:" + responseObject.errorMessage);
    }
    console.log("connection lost");
}

function onConnectFail(e) {
    console.log(e);
    console.log("doFail");

    setInterval(function () { client.connect(options); }, 1000*30);
}

function onMessageArrived(message) {
  console.log('broker msg', message);

  let data;
  try {
    data = JSON.parse(message.payloadString);
  } catch(error) {
    $('#monitor_table tbody').prepend('<tr><td>parse error</td><td></td><td><code>' + message.payloadString + '</code></d>'); 
    return;
  }

    let source, timestamp, ddc, payload, date;

    // is it a new style message?
    if(data["source"]) {
        source = data["source"];
        timestamp = data["timestamp"];
        try {
            ddc = data["contents"]["ddc"];
            payload = data["contents"]["payload"];
        } catch(error) {
          $('#monitor_table tbody').prepend('<tr><td><a href="/devices/' + source +  '">' + source + '</td><td>parse error</td><td><code>' + message.payloadString + '</code></d>'); 
          return;
        }
    }

  try {
    datetime = format_date(new Date(timestamp * 1000));
 } catch(error) {
    datetime = "invalid";
 }

  if(monitor_params["uuid_name_map"][source])
    source = '<a href="/devices/' + source + '">' + monitor_params["uuid_name_map"][source] + '</a>';
  else
    source = '<a href="/devices/' + source + '">' + source + '</a>';

    $('#monitor_table tbody').prepend('<tr><td>' + source + '</td><td>' + ddc + '</td><td>' + datetime + '</td><td><code>' + JSON.stringify(payload) + '</code></td></tr>');
}

function format_date(datetime) {
    let hours = datetime.getHours();
    let minutes = datetime.getMinutes();
    let seconds = datetime.getSeconds();
    let year = datetime.getYear();

    hours = hours < 10 ? '0' + hours : hours;
    minutes = minutes < 10 ? '0' + minutes : minutes;
    seconds = seconds < 10 ? '0' + seconds : seconds;
    year = year < 100 ? year : year - 100;

    return hours + ':' + minutes + ':' + seconds + '  ' + (datetime.getMonth() + 1) + '/' + datetime.getDate() + '/' + datetime.getYear();
}
