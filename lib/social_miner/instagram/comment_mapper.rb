# frozen_string_literal: true

module SocialMiner
  module Instagram
    class CommentMapper < Mapper
      map "id",   to: :social_id
      map "text", to: :body

      map "created_at", to: :published_at do |val|
        Time.at(val) if val
      end
    end
  end
end
