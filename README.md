# SocialMiner

SocialMiner is a Ruby gem that provides a simple interface to fetch public data from Instagram, including user profiles, posts, and comments.

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'social_miner'
```

And then execute:

```bash
bundle install
```

# Usage
Fetch user profile info:

```ruby
result = SocialMiner::Instagram.profile_info(username: "instagram")
# Result contains:
# {
#   social_id: "123456789",
#   username: "instagram_username",
#   description: "User bio",
#   first_name: "John",
#   last_name: "Doe",
#   avatar_url: "https://...",
#   followers: 1000,
#   following: 500
# }
```

To fetch a user's posts:

```ruby
# User ID can be obtained from the profile info (social_id field)
result = SocialMiner::Instagram.profile_posts(user_id: "user_id")

# Result contains:
# {
#   cursor: "next_page_token",
#   records: [
#     {
#       social_id: "post123",
#       image_url: "https://...",
#       shortcode: "ABC123",
#       location_name: "New York",
#       description: "Post caption",
#       published_at: 2024-03-20 12:00:00
#     }
#   ]
# }

# To fetch next page:
next_page = SocialMiner::Instagram.profile_posts(user_id: "user_id", cursor: result[:cursor])
```

To fetch comments on a specific post:

```ruby
result = SocialMiner::Instagram.post_comments(post_shortcode: "ABC123")

# Result contains:
# {
#   cursor: "next_page_token",
#   records: [
#     {
#       social_id: "comment123",
#       body: "Great post!",
#       published_at: 2024-03-20 12:00:00
#     }
#   ]
# }

# To fetch next page of comments:
next_page = SocialMiner::Instagram.post_comments(post_shortcode: "ABC123", cursor: result[:cursor])
```

# Custom Headers

You can pass custom headers to the requests by passing a hash to the `request_headers` option:

```ruby
SocialMiner::Instagram.profile_info({ "Custom-Header" => "Header-Value" }, username: 'instagram')
```

# Custom Mapper

You can use a custom mapper to transform the data into a custom structure.

```ruby
class CustomMapper < SocialMiner::Mapper
  # Map a single key
  map "id", to: "user_id"

  # Map a nested key
  map %w[profile name], to: "full_name"

  # Make fields optional
  map "profile_pic_url", to: "avatar_url", optional: true

  # Map a key with a custom transformation
  map "created_at", to: "published_at" do |value|
    Time.parse(value) if value
  end
end
```

Use your custom mapper:

```ruby
SocialMiner::Instagram.profile_info(username: "instagram", mapper: CustomMapper)
```

Or even you can use any your own mapper, the only requirement is to respond `.call` method. For example:

```ruby
module CustomMapper
  def call(attrs)
    {
      id: attrs['id']
    }
  end

  module_function :call
end
```

### Default Mappers

The gem includes several default mappers:

- `ProfileMapper`: Maps user profile information
  ```ruby
  {
    social_id: String,     # Instagram user ID
    username: String,      # Instagram username
    description: String,   # User bio
    full_name: String,     # Full name
    avatar_url: String,    # Profile picture URL
    followers: Integer,    # Followers count
    following: Integer     # Following count
  }
  ```

- `PostMapper`: Maps post information
  ```ruby
  {
    social_id: String,      # Instagram post ID
    image_url: String,      # Post image URL
    shortcode: String,      # Post shortcode
    location_name: String,  # Location name (optional)
    description: String,    # Post description
    published_at: Time      # Post creation timestamp
  }
  ```

- `CommentMapper`: Maps comment information
  ```ruby
  {
    social_id: String,     # Comment ID
    body: String,          # Comment text
    published_at: Time     # Comment timestamp
  }
  ```

# Requirements

- Ruby 3.2+

# License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

⚠️ **DISCLAIMER**

This gem is provided for educational purposes only. Please note:

1. This tool is not officially associated with Instagram or Meta Platforms, Inc.
2. Using this gem might violate Instagram's Terms of Service.
3. The author(s) of this gem:
   - Take no responsibility for how you use this software
   - Are not liable for any damages resulting from its use
   - Are not responsible for any legal consequences that may arise from its use

By using this gem, you acknowledge that:
- You are solely responsible for complying with all applicable laws and terms of service
- You will use this tool responsibly and at your own risk
- You understand that Instagram's API changes may break this gem's functionality at any time