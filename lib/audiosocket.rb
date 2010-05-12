require "configlet"
require "rest_client"

module Audiosocket
  extend Configlet

  # Duh.

  VERSION = "0.0.0"

  config :audiosocket do
    default :token => "no-token-provided"
    default :url   => "http://audiosocket.com/api/v3"
  end

  RestClient.add_before_execution_proc do |req, params|
    if params[:url].include? self[:url]
      req["X-Audiosocket-Token"] = self[:token]
    end

    p :req => req, :params => params
  end

  def self.delete url, headers = {}, &block
    RestClient.delete maybe_prefix(url), headers, &block
  end

  def self.get url, headers = {}, &block
    RestClient.get maybe_prefix(url), headers, &block
  end

  def self.head url, headers = {}, &block
    RestClient.head maybe_prefix(url), headers, &block
  end

  def self.post url, payload, headers = {}, &block
    RestClient.post maybe_prefix(url), payload, headers, &block
  end

  def self.put url, payload, headers = {}, &block
    RestClient.put maybe_prefix(url), payload, headers, &block
  end

  def self.maybe_prefix url #:nodoc:
    return url if /^http/ =~ url
    File.join self[:url], url
  end
end
