require "http"

module Notion
  class Base
    def initialize(params)
      @params = params
      @base = "https://api.notion.com/v1"
      p send_request.to_s
    end

    def base_url(service = "")
      "#{@base}#{service}"
    end

    def request_with_headers
      HTTP.headers(
        "accept" => "application/json",
        "Notion-Version" => "2021-05-13"
      ).auth("Bearer #{ENV["NOTION_SECRET"]}")
    end
  end
end