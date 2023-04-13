package no.obrien.twitflow;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.twitter.models.FilteredStreamingTweetOneOf;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class TwitterApiObjectMapperTest {

  @Autowired
  private ObjectMapper twitterApiObjectMapper;

  @Test
  void readValue_twitterResponse_mapsToDomainObject() throws JsonProcessingException {
    @SuppressWarnings("checkstyle:linelength")
    var json = "{\"data\":{\"author_id\":\"1393285420998447105\",\"created_at\":\"2021-10-29T16:44:06.000Z\",\"id\":\"1454126911211311113\",\"text\":\"RT @JibachuLaloutre: Imagine t'es anglophone, tu veux t'intéresser au #ZEVENT2021, tu va sur le stream avec le plus de viewers et t'as un v…\"},\"includes\":{\"users\":[{\"id\":\"1393285420998447105\",\"name\":\"Maddy uu\",\"username\":\"maddylavie\"},{\"id\":\"1127989042182799360\",\"name\":\"Surf Rock Mansion Shopkeep\",\"username\":\"JibachuLaloutre\"}]}}";
    var streamingTweet = twitterApiObjectMapper
        .readValue(json, FilteredStreamingTweetOneOf.class);

    assertNotNull(streamingTweet.getData());
    assertNotNull(streamingTweet.getIncludes());
    assertNotNull(streamingTweet.getIncludes().getUsers());

    assertEquals("1393285420998447105", streamingTweet.getData().getAuthorId());
    assertEquals("1454126911211311113", streamingTweet.getData().getId());
    assertEquals("maddylavie", streamingTweet.getIncludes().getUsers().get(0).getUsername());
  }
}
