require "http"

class NotionRequest
  def initialize(params)
    @params = params
    @base = "https://api.notion.com/v1/pages"
  end

  def create_ticket
    HTTP.headers(accept: "application/json", )
        .auth("Bearer #{ENV["NOTION_SECRET"]}")
        .post(@base, json: body)
  end

  def destroy_ticket
    HTTP.headers(accept: "application/json", )
        .auth("Bearer #{ENV["NOTION_SECRET"]}")
        .delete(@base, json: body)
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
        "Category": {
          "select": {
            "name": "Sentry issues"
          }
        },
        "URL": {
          "url": "https://sentry.io/organizations/#{@params[:app_slug]}/issues/#{@params[:issue_id]}"
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