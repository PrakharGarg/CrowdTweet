Parse.Cloud.afterSave ("Tweets", function(request, response) {
  console.log(request.object.get("tweet"));

  var tweetLength = String((request.object.get("tweet"))).length;

  console.log(tweetLength);
});
