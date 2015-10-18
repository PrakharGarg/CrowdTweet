Parse.Cloud.afterSave ("Tweets", function(request, response) {
  console.log(request.object.get("tweet"));

  var handleArray = String((request.object.get("handle")));

  var tweetLength = 1 + String((request.object.get("tweet"))).length;
  var handleLength = 1 + handleArray.length;
  var numberOfHandles = request.object.get("handle").split(" ").length - 1;
  var totalLength = tweetLength + handleLength + numberOfHandles;

  console.log("The total length is " + totalLength);

  if (140 - totalLength < 55){
    // Tweet it out! 
  }


});
