$(document).ready(function() {
    if(typeof monitor_params == 'undefined') {
	return;
    }

    client = new Paho.Client(monitor_params['broker']['server'], monitor_params['broker']['port'], monitor_params['broker']['client_id']);

    client.onConnectionLost = onConnectionLost; 
    client.onMessageArrived = onMessageArrived;

    var options = {
	useSSL: true,
	userName: monitor_params['broker']['username'],
	password: monitor_params['broker']['password'],
	onSuccess: onConnect,
	onFailure: onConnectFail,
	reconnect: true
    };

    client.connect(options); 
});

function onConnect() {
console.log('mqtt connected');
  monitor_params['ddcs'].forEach(function(ddc) {
    client.subscribe('homebus/device/+/' + ddc);
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
}

function onMessageArrived(message) {
  console.log('mqtt msg', message);

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
    date = new Date(timestamp * 1000);
 } catch(error) {
    date = "invalid";
 }

  $('#monitor_table tbody').prepend('<tr><td>' + source + '</td><td>' + ddc + '</td><td>' + date + '</td><td><code>' + JSON.stringify(payload) + '</code></td></tr>');
}
