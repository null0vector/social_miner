# frozen_string_literal: true

module SocialMiner
  module Instagram
    class ProfileMapper < Mapper
      map "id",        to: :social_id
      map "biography", to: :description, optional: true
      map "username",  to: :username
      map "full_name", to: :full_name

      map "profile_pic_url", to: :avatar_url

      map %w[edge_followed_by count], to: :followers
      map %w[edge_follow count],      to: :following
    end
  end
end
