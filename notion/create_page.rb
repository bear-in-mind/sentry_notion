require "http"

module Notion
  class CreatePage < Notion::Base

    def initialize(params)
      # TODO: Change to your own properties
      @page_category_property_name = "Category"
      @page_category_property_value = "Sentry issues"
      @page_url_property = "URL"
      super(params)
    end

    def send_request
      request_with_headers.post(base_url("/pages"), json: body)
    end
    
    private

    def body
      {
        "parent": {
          "database_id": ENV["NOTION_DB"]
        },
        "properties": {
          "Name": {
            "title": [
              {
                "text": {
                  "content": "#{@params[:title]}"
                }
              }
            ]
          },
          "#{@page_category_property_name}": {
            "select": {
              "name": @page_category_property_value
            }
          },
          "#{@page_url_property}": {
            "url": "https://sentry.io/organizations/#{@params[:app_slug]}/issues/#{@params[:issue_id]}"
          },
          "issue_id": {
            "rich_text": [
              {
                "text": {
                  "content": "#{@params[:issue_id]}"
                }
              }
            ]
          }
        },
        "children": [
          {
            "object": "block",
            "type": "paragraph",
            "paragraph": {
              "text": [
                {
                  "type": "text",
                  "text": {
                    "content": @params[:message]
                  }
                }
              ]
            }
          }
        ]
      }
    end
  end
end