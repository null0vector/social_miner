# frozen_string_literal: true

require_relative "social_miner/version"

require_relative "social_miner/hash_extension"
require_relative "social_miner/mapper"

require_relative "social_miner/instagram/base"
require_relative "social_miner/instagram/profile_info"
require_relative "social_miner/instagram/profile_mapper"
require_relative "social_miner/instagram/profile_posts"
require_relative "social_miner/instagram/post_mapper"
require_relative "social_miner/instagram/post_comments"
require_relative "social_miner/instagram/comment_mapper"

module SocialMiner
  module Dispatcher
    def call(klass, request_options:, **args)
      instance =
        if request_options.empty?
          klass.new
        else
          klass.new(**request_options)
        end

      instance.call(**args)
    end

    module_function :call
  end

  def Instagram.profile_info(request_options: {}, **args)
    Dispatcher.call(Instagram::ProfileInfo, request_options: request_options, **args)
  end

  def Instagram.profile_posts(request_options: {}, **args)
    Dispatcher.call(Instagram::ProfilePosts, request_options: request_options, **args)
  end

  def Instagram.post_comments(request_options: {}, **args)
    Dispatcher.call(Instagram::PostComments, request_options: request_options, **args)
  end
end
