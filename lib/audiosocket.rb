require "configlet"
require "rest_client"
require "uri"

module Audiosocket
  extend Configlet

  # Duh.

  VERSION = "1.0.0"

  config :audiosocket do
    default :token => "no-token-provided"
    default :url   => "http://audiosocket.com/api/v3"

    munge(:url) { |url| URI.parse url  }
  end

  RestClient.add_before_execution_proc do |req, params|
    p :req => req, :params => params
  end
end
