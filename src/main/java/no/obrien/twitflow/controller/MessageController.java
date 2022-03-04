package no.obrien.twitflow.controller;

import lombok.RequiredArgsConstructor;
import no.obrien.twitflow.provider.TwitterApiProvider;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
public class MessageController {

  private final TwitterApiProvider twitterApiProvider;

  @MessageMapping("/start-tweet-stream")
  public void startTweetStream() {
    this.twitterApiProvider.openTwitterTweetStream();
  }

  @MessageMapping("/stop-tweet-stream")
  public void stopTweetStream() {
    this.twitterApiProvider.closeTwitterTweetStream();
  }
}
