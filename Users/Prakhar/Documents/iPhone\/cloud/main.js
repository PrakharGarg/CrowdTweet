var oauth = require('cloud/oauth.js');
var sha = require('cloud/sha1.js');

Parse.Cloud.afterSave ("Tweets", function(request, response) {
  var handleArray = String((request.object.get("handle")));
  var tweetLength = 1 + String((request.object.get("tweet"))).length;
  var handleLength = 1 + handleArray.length;
  var handles = request.object.get("handle").split(" ");
  var numberOfHandles = handles.length - 1;
  var totalLength = tweetLength + handleLength + numberOfHandles;

  console.log(handles);
  console.log("The total length is " + totalLength);

  var tweet = String((request.object.get("tweet")));

  for ( var i = 0; i <= numberOfHandles; i++ ){
    tweet = tweet +  " @" + handles[i];
  }

  console.log(tweet);


  var urlLink = 'https://api.twitter.com/1.1/statuses/update.json';

  var postSummary = tweet;
  var status = oauth.percentEncode(postSummary);
  var consumerSecret = "RPIdmNtmya0cUvqD2HbWlIumXpKSow2aeXd8gCFfhikC552k7T";
  var tokenSecret = "RDhPCdppdia6EIZLA4iVITl7a9rLqRxL3TePpQvGOsPo4";
  var oauth_consumer_key = "jfK3bEVl07VHpRF7Df2Q2xgSW";
  var oauth_token = "3749894000-qkmgSL35W0DNUbBXb2vcNTA6lJrYos88AJcwnF9";

  var nonce = oauth.nonce(32);
  var ts = Math.floor(new Date().getTime() / 1000);
  var timestamp = ts.toString();

  var accessor = {
    "consumerSecret": consumerSecret,
    "tokenSecret": tokenSecret
  };


  var params = {
    "status":postSummary,
    "oauth_version": "1.0",
    "oauth_consumer_key": oauth_consumer_key,
    "oauth_token": oauth_token,
    "oauth_timestamp": timestamp,
    "oauth_nonce": nonce,
    "oauth_signature_method": "HMAC-SHA1"
  };
  var message = {
    "method": "POST",
    "action": urlLink,
    "parameters": params
  };


  //lets create signature
  oauth.SignatureMethod.sign(message, accessor);
  var normPar = oauth.SignatureMethod.normalizeParameters(message.parameters);
  console.log("Normalized Parameters: " + normPar);
  var baseString = oauth.SignatureMethod.getBaseString(message);
  console.log("BaseString: " + baseString);
  var sig = oauth.getParameter(message.parameters, "oauth_signature") + "=";
  console.log("Non-Encode Signature: " + sig);
  var encodedSig = oauth.percentEncode(sig); //finally you got oauth signature
  console.log("Encoded Signature: " + encodedSig);

  Parse.Cloud.httpRequest({
    method: 'POST',
    url: urlLink,
    headers: {
      "Authorization": 'OAuth oauth_consumer_key="'+oauth_consumer_key+'", oauth_nonce=' + nonce + ', oauth_signature=' + encodedSig + ', oauth_signature_method="HMAC-SHA1", oauth_timestamp=' + timestamp + ',oauth_token="'+oauth_token+'", oauth_version="1.0"'
    },
    body: "status="+status,
    success: function(httpResponse) {
      response.success(httpResponse.text);
    },
    error: function(httpResponse) {
      response.error('Request failed with response ' + httpResponse.status + ' , ' + httpResponse);
    }
  });



});
