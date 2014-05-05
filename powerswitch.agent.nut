const PASSWORD = "yourpassword"

// agent code:
function httpHandler(request, response) {
    try {
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

        // if they passed a power parameter
        if ("power" in request.query) {
            // grab the power parameter
            local powerState = request.query["power"].tointeger();
            
            // send it to the device
            device.send("power", powerState);

            // finally, send a response back to whoever made the request
            response.send(200, "OK");
        } else {
            // if user forgot the "power" parameter give them a handy message:
            response.send(400, "Missing Parameter(s). Make sure you include ?power={state}&pw={youpassword} in the URL");
        }
    }
    catch (ex) {
        // if there was an error, send back a response with the error
        response.send(500, "Agent Error - " + ex);
    }
}

// run httpHandler whenever a request comes into the Agent URL
http.onrequest(httpHandler);

