require "http"

module Notion
  class UpdatePage < Notion::Base

    def initialize(params)
      @status_property = "Status"
      @status_value = "Done"
      super(params)
    end

    def get_pages
      response = request_with_headers.post(
        base_url("/databases/#{ENV["NOTION_DB"]}/query"),
        json: query
      )
      JSON.parse(response.to_s)
    end

    def mark_as_done(page_id)
      request_with_headers.patch(base_url("/pages/#{page_id}"), json: body)
    end
    
    def send_request
      pages = get_pages["results"].map { |p| p["id"] }
      pages.each {|p| mark_as_done(p) }
    end
    
    private

    def body
      {
        "properties": {
          "#{@status_property}": {
            "select": {
              "name": @status_value
            }
          }
        }
      }
    end

    def query
      {
        filter: {
          property: "issue_id",
          text: {
            equals: @params[:issue_id].to_s
          }
        }
      }
    end
  end
end