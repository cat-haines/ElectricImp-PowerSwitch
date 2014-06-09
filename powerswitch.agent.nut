const html = @"
<!DOCTYPE html>
<html lang='en'>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>PowerSwitch Tail</title>
    
    <link rel='stylesheet' href='https://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css'>
  </head>
  <body>
    <div class='container col-xs-12 col-sm-4 col-sm-offset-4 text-center'>
      <h1>PowerSwitch</h1>
      <div class='well'>
        <div class='btn-group'>
          <button type='button' class='btn btn-default' onclick='setState(1);'>On</button>
          <button type='button' class='btn btn-default' onclick='setState(0);'>Off</button>
        </div>
        <input type='password' class='form-control' style='margin-top:15px; text-align:center;' id='pw' placeholder='Password'>
      </div>
      <div class='text-left'>
        <h2>Log:</h2>
        <div id='logs'></div>
      </div>
    <script src='https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js'></script>
    <script src='https://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js'></script>
    <script>
        function setState(s) {
            var pw = $('#pw').val();
            var url = document.URL + '?pw=' + pw + '&power=' + s;

            if (pw) {
                $.get(url)
                    .done(function(data) {
                        $('#logs').prepend('<span style=\'color: green;\'>' + new Date().toLocaleString() + '</span><span> - Turned power ' + data + '</span><br />');
                    })
                    .fail(function(data) {
                        alert('ERROR: ' + data.responseText);
                    });
            } else {
                alert('Please enter a password and try again');
            }
        }
    </script>
  </body>
</html>
"

const PASSWORD = "yourpassword"

// agent code:
function httpHandler(request, response) {
    try {
        // if they passed a power parameter
        if ("power" in request.query) {
            // add the ajax header
            response.header("Access-Control-Allow-Origin", "*");
            
            // password variable
            local pw = null;
            
            // if they passed a password
            if ("pw" in request.query) {
                // grab the pw parameter
                pw = request.query["pw"];
            }
    
            // if the password was wrong
            if (pw != PASSWORD) {
                // send back an angry message
                response.send(401, "UNAUTHORIZED");
                return;
            }

            // grab the power parameter
            local powerState = request.query["power"].tointeger();
            if (powerState == 0 || powerState == 1) {
                // send it to the device
                device.send("power", powerState);

                // finally, send a response back to whoever made the request
                response.send(200, powerState == 0 ? "Off" : "On");
                return;
            } else {
                // if powerState isn't valid, send back an error message
                response.send(500, "Invalid power parameter. Please pass 1 or 0 and try again.");
                return;
            }
        } else {
            // if power wasn't specified, send back the HTML page
            response.send(200, html);
            return;
        }
    }
    catch (ex) {
        // if there was an error, send back a response with the error
        response.send(500, ex);
        return;
    }
}

// run httpHandler whenever a request comes into the Agent URL
http.onrequest(httpHandler);

