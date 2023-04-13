package no.obrien.twitflow;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.twitter.models.Expansions;
import com.twitter.models.FilteredStreamingTweetOneOf;
import com.twitter.models.Tweet;
import com.twitter.models.User;
import java.time.OffsetDateTime;
import no.obrien.twitflow.mapper.TweetDtoMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class TweetDtoMapperTest {

  @Autowired
  private TweetDtoMapper tweetDtoMapper;

  @Test
  void fromStreamingTweet_validInput_mapsWithoutIssue() {
    OffsetDateTime now = OffsetDateTime.now();

    var tweet = new Tweet()
        .text("this is the tweet text")
        .authorId("12345")
        .createdAt(now);

    var author = new User()
        .id("12345")
        .username("AuthorUsername");

    var expansions = new Expansions().addUsersItem(author);

    var streamingTweet = new FilteredStreamingTweetOneOf()
        .data(tweet)
        .includes(expansions);

    var tweetDto = tweetDtoMapper.fromStreamingTweet(streamingTweet);

    assertEquals(tweetDto.getText(), tweet.getText());
    assertEquals(tweetDto.getAuthor(), author.getUsername());
  }
}
