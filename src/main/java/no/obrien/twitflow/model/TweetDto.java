package no.obrien.twitflow.model;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class TweetDto {

  String author;
  String text;
  String createdAt;
}
