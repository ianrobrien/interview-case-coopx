package no.obrien.twitflow.mapper;

import com.twitter.models.StreamingTweet;
import com.twitter.models.User;
import no.obrien.twitflow.model.TweetDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Objects;

@Mapper(componentModel = "spring")
public interface TweetDtoMapper {

  DateTimeFormatter HUMAN_READABLE_DATE_TIME_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

  /**
   * Maps a StreamingTweet from the Twitter domain to a TweetDto instance in the twitflow domain
   *
   * @param streamingTweet the Twitter streaming tweet domain object
   * @return the twitflow tweet domain object
   */
  @Mapping(target = "text", source = "data.text")
  @Mapping(target = "author", source = "streamingTweet")
  @Mapping(target = "createdAt", source = "data.createdAt")
  TweetDto fromStreamingTweet(StreamingTweet streamingTweet);

  /**
   * Maps the author from the streaming tweet
   *
   * @param streamingTweet the Twitter streaming tweet domain object
   * @return the author of the tweet
   */
  default String mapAuthor(StreamingTweet streamingTweet) {
    if (streamingTweet.getIncludes() == null) {
      return null;
    }
    if (streamingTweet.getIncludes().getUsers() == null) {
      return null;
    }
    if (streamingTweet.getData() == null) {
      return null;
    }
    if (streamingTweet.getData().getAuthorId() == null) {
      return null;
    }

    return streamingTweet.getIncludes()
        .getUsers()
        .stream()
        .filter(u -> Objects.equals(u.getId(), streamingTweet.getData().getAuthorId()))
        .map(User::getUsername)
        .findFirst()
        .orElse(null);
  }

  /**
   * Maps the created at time and date to a human friendly format
   *
   * @param createdAt the created at time and date of the tweet
   * @return the human readable string representation
   */
  default String mapCreatedAt(OffsetDateTime createdAt) {
    return createdAt.toLocalDateTime().format(HUMAN_READABLE_DATE_TIME_FORMAT);
  }
}
