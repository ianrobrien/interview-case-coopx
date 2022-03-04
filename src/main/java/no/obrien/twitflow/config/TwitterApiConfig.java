package no.obrien.twitflow.config;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
public class TwitterApiConfig {

  @Value("${twitter.api.bearer-token}")
  public String twitterApiBearerToken;

  @Bean
  public ObjectMapper twitterApiObjectMapper() {
    return new ObjectMapper()
        .disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES)
        .setPropertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE)
        .registerModule(new JavaTimeModule());
  }
}
