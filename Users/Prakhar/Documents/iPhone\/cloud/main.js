Parse.Cloud.afterSave ("Tweets", function(request, response) {
  console.log(request.object.get("tweet"));

  var tweetLength = 1 +  String((request.object.get("tweet"))).length + String((request.object.get("handle"))).length;
  console.log(tweetLength);

});
