require "http"

module Notion
  class CreatePage < Notion::Base
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
          "#{@category_property}": {
            "select": {
              "name": @category_value
            }
          },
          "#{@url_property}": {
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