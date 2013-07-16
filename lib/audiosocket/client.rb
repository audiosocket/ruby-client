require "audiosocket/errors"
require "faraday"
require "faraday_middleware"

module Audiosocket
  class Client
    attr_reader :conn
    attr_reader :url

    def initialize options = {}
      @url = options[:url] || "https://api.audiosocket.com/v5"

      @conn = Faraday.new url: @url do |f|
        f.request :json
        f.adapter Faraday.default_adapter
      end

      @conn.headers["X-Audiosocket-Token"] =
        options.values_at(:token, :uid).compact.join ":"
    end

    # Auth a user given a temporary token or email and password.

    def auth email_or_token, password = nil
      password ? post("auth", email: email_or_token, password: password) :
        post("auth/#{email_or_token}")
    end

    # Handle and transform Faraday's response. `404` responses return
    # `nil`. Responses from `200` to `299` and `422` parse the body as
    # JSON.

    def handle res, opts = {}
      parse = opts.has_key?(:parse) ? opts[:parse] : true

      case res.status
      when 200..299, 422 then JSON.parse res.body if parse
      when 401, 403      then raise Audiosocket::Unauthorized
      when 404           then nil

      else
        raise "Unexpected response (#{res.status}) from the API:\n#{res.body}"
      end
    end

    # Send a GET to the API, handling the response.

    def get *args, &block
      handle @conn.get *args, &block
    end

    # Send a DELETE to the API, handling the response.

    def delete *args, &block
      res = @conn.delete *args, &block
      handle res, parse: false
    end

    # Send a POST to the API, handling the response.

    def post *args, &block
      handle @conn.post *args, &block
    end

    # Send a PUT to the API, handling the response.

    def put *args, &block
      handle @conn.put *args, &block
    end

    def to_s
      "#<Audiosocket::Client #{url}>"
    end

    # Create a temporary token for the client's current token/uid
    # credentials.

    def tokenize
      post("token")["token"]
    end
  end
end
