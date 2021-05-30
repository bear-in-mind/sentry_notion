require "http"

module Notion
  class Base
    attr_reader :status_property, :status_value, :category_property, :category_value

    def initialize(params = nil)
      @params = params
      @base = "https://api.notion.com/v1"
      # TODO: Change to your own properties
      @status_property = "Status"
      @status_value = "Done"
      @category_property = "Category"
      @category_value = "Sentry issues"
      @url_property = "URL"
      send_request.to_s unless params.nil? # Allow reuse of Notion::UpdatePage in job
    end

    def get_pages(query)
      response = request_with_headers.post(
        base_url("/databases/#{ENV["NOTION_DB"]}/query"),
        json: query
      )
      JSON.parse(response.to_s)
    end

    private

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