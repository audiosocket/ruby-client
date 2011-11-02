require "faraday"
require "json"

module Audiosocket
  class Client
    attr_reader :conn
    attr_reader :url

    def initialize options = {}
      @url = options[:url] || "https://api.audiosocket.com/v5"
      
        
      @conn = Faraday.new url: @url do |f|
        f.use Faraday::Request::JSON
        f.use Faraday::Adapter::NetHttp
      end

      @conn.headers["X-Audiosocket-Token"] =
        options.values_at(:token, :uid).compact.join ":"
    end

    # Auth a user given a temporary token or email and password.

    def auth email_or_token, password = nil
      password ? post("auth", email: email_or_token, password: password) :
        post("auth/#{email_or_token}")
    end

    # Send a GET to the API, handling the response.

    def get *args, &block
      handle @conn.get *args, &block
    end

    # Handle and transform Faraday's response. `404` responses return
    # `nil`. Responses from `200` to `299` and `422` parse the body as
    # JSON.

    def handle res
      body = res.body

      case res.status
      when 200..299, 422 then JSON.parse body
      when 404 then nil
      else raise "#{res.status}: #{res.body}"
      end
    end

    # Send a POST to the API, handling the response.

    def post *args, &block
      handle @conn.post *args, &block
    end

    # Send a PUT to the API, handling the response.

    def put *args, &block
      handle @conn.put *args, &block
    end

    # Create a temporary token for the client's current token/uid
    # credentials.

    def tokenize
      post("token")["token"]
    end
  end
end
