package no.obrien.twitflow.provider;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.twitter.models.FilteredStreamingTweetOneOf;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import no.obrien.twitflow.config.TwitterApiConfig;
import no.obrien.twitflow.mapper.TweetDtoMapper;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpStatus;
import org.apache.http.client.config.CookieSpecs;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.HttpClients;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class TwitterApiProvider {

  private final TwitterApiConfig twitterApiConfig;
  private final SimpMessageSendingOperations simpMessageSendingOperations;
  private final TweetDtoMapper tweetDtoMapper;
  private final ObjectMapper twitterApiObjectMapper;

  private static final String TWITTER_STREAM_URL =
      "https://api.twitter.com/2/tweets/sample/stream?expansions=author_id&tweet.fields=created_at";

  // Indicates that the connection should be kept open
  private boolean keepConnectionOpen;

  // Indicates that there is a stream open between the API Provider and Twitter
  private boolean isConnectionOpen;

  /** Open a streaming connection to Twitter and send tweets to the message queue */
  public void openTwitterTweetStream() {
    if (this.isConnectionOpen) {
      return;
    }
    if (StringUtils.isEmpty(twitterApiConfig.getTwitterApiBearerToken())) {
      throw new RuntimeException("Could not load bearer token from configuration.");
    }

    this.keepConnectionOpen = true;
    this.isConnectionOpen = true;

    var httpClient =
        HttpClients.custom()
            .setDefaultRequestConfig(
                RequestConfig.custom().setCookieSpec(CookieSpecs.STANDARD).build())
            .build();

    try (httpClient) {
      var uriBuilder = new URIBuilder(TWITTER_STREAM_URL);

      var httpGet = new HttpGet(uriBuilder.build());
      httpGet.setHeader(
          "Authorization", String.format("Bearer %s", twitterApiConfig.getTwitterApiBearerToken()));

      try (var response = httpClient.execute(httpGet)) {
        if (response.getStatusLine().getStatusCode() != HttpStatus.SC_OK) {
          throw new RuntimeException(
              "Did not get OK response from Twitter. Received: " + response.getStatusLine());
        }
        try (var reader =
            new BufferedReader(new InputStreamReader((response.getEntity().getContent())))) {
          var tweetJson = reader.readLine();
          while (tweetJson != null) {
            this.sendTweetMessage(tweetJson);
            tweetJson = reader.readLine();
            if (!this.keepConnectionOpen) {
              response.close();
            }
          }
        }
      }
    } catch (Exception ex) {
      log.error(ex.toString(), ex);
    } finally {
      this.isConnectionOpen = false;
    }
  }

  /** Stop streaming Tweets from Twitter, closing the streams */
  public void closeTwitterTweetStream() {
    this.keepConnectionOpen = false;
  }

  private void sendTweetMessage(String tweetJson) {
    try {
      var streamingTweet =
          twitterApiObjectMapper.readValue(tweetJson, FilteredStreamingTweetOneOf.class);
      simpMessageSendingOperations.convertAndSend(
          "/topic/tweets", tweetDtoMapper.fromStreamingTweet(streamingTweet));
    } catch (Exception ex) {
      log.error(ex.getMessage());
    }
  }
}
