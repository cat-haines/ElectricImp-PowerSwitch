// agent code:
function httpHandler(request, response) {
    try {
        // if they included "?power=something" in the URL
        if ("power" in request.query) {
            // grab what power was set to
            local powerState = request.query["power"].tointeger();
            // send it to the device
            device.send("power", powerState);
            // send a response back to whoever made the request
            response.send(200, "OK");
        } else {
            // if user forgot the "power" parameter give them a handy message:
            response.send(400, "No Power parameter. Add ?power=1 to the end of the URL to turn the device on");
        }
    }
    catch (ex) {
        // if there was an error, send back a response with the error
        response.send(500, "Agent Error - " + ex);
    }
}

// run httpHandler whenever a request comes into the Agent URL
http.onrequest(httpHandler);

