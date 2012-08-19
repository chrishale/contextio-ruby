require 'uri'

module ContextIO
  module API
    VERSION = '2.0'

    def self.version
      VERSION
    end

    def self.path(command, params = {})
      path = "/#{ContextIO::API.version}/#{command}"

      unless params.empty?
        path << "?#{paramaterize(params)}"
      end

      path
    end

    def self.paramaterize(params)
      params = params.inject({}) do |memo, (k, v)|
        memo[k] = Array(v).join(',')

        memo
      end

      URI.encode_www_form(params)
    end

    %w(get delete put post).each do |action|
      self.class.send(:define_method, action) do |token, command, params = {}|
        token.send(action, path(command, params), 'Accept' => 'application/json')
      end
    end
  end
end