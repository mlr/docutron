require 'slack-ruby-bot'
require_relative 'docutron/response'

module Docutron
  class App < SlackRubyBot::App
  end

  class SlackBot < SlackRubyBot::Commands::Base
    DOC_REQUEST = /^(?<request_method>\w*) (?<resource>\w*)$/

    match DOC_REQUEST do |client, data, match|
      method, resource = match[:request_method], match[:resource]
      response = Docutron::Response.new(method, resource)
      response.send(client, data.channel)
    end
  end
end

Docutron::App.instance.run
