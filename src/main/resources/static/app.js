let stompClient = null;

window.onload = function () {
  $("#waitMessage").hide();
  $("#tweetsTable").hide();
};

function start() {
  const socket = new SockJS('/twitflow-websocket');
  stompClient = Stomp.over(socket);
  stompClient.connect({}, function () {
    setStarted(true);
    stompClient.subscribe('/topic/tweets', function (tweet) {
      showTweet(JSON.parse(tweet.body));
    });
    stompClient.send("/app/start-tweet-stream");
  });
}

function stop() {
  if (stompClient !== null) {
    stompClient.send("/app/stop-tweet-stream");
    stompClient.disconnect();
  }
  setStarted(false);
}

function showTweet(tweet) {
  $("#waitMessage").hide();
  $("#tweetsTable").show();
  $("#tweets").append(
      "<tr>"
      + "<td>" + tweet.author + "</td>"
      + "<td>" + tweet.created_at + "</td>"
      + "<td>" + tweet.text + "</td>"
      + "</tr>");
}

function setStarted(started) {
  if (started) {
    $("#waitMessage").show();
  } else {
    $("#waitMessage").hide();
  }
  $("#start").prop("disabled", started);
  $("#clear").prop("disabled", started);
  $("#stop").prop("disabled", !started);
}

function clear() {
  $("#tweets").empty()
  $("#clear").prop("disabled", true);
  $("#tweetsTable").hide();
}

$(function () {
  $("form").on('submit', function (e) {
    e.preventDefault();
  });
  $("#start").click(function () {
    start();
  });
  $("#stop").click(function () {
    stop();
  });
  $("#clear").click(function () {
    clear();
  });
});
