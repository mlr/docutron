require 'prmd'

module Docutron
  class Response
    UnknownResponse = "Sorry, I don't know about that resource.".freeze

    def initialize(method, resource)
      @method   = method.upcase
      @resource = resource
      @schemata = "#/definitions/#{@resource}"
      @schema   = Prmd::Schema.new(JSON.parse(File.read('schema.json')))
    end

    def link
      @schema['definitions'][@resource]['links'].detect do |link|
        link['method'] == @method
      end or raise UnknownResponse
    end

    def json_example
      if link['rel'] == 'empty'
      elsif link.has_key?('targetSchema')
        JSON.pretty_generate(@schema.schema_example(link['targetSchema']))
      elsif link['rel'] == 'instances'
        JSON.pretty_generate([@schema.schemata_example(@schemata)])
      else
        JSON.pretty_generate(@schema.schemata_example(@schemata))
      end
    end

    def message
      "```#{json_example}```"
    end

    def send(client, channel)
      client.message text: message, channel: channel
    end
  end
end
