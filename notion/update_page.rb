require "http"

module Notion
  class UpdatePage < Notion::Base    
    def mark_as_done(page_id)
      request_with_headers.patch(base_url("/pages/#{page_id}"), json: body)
    end
    
    def send_request
      pages = get_pages(by_issue_id_query)["results"].map { |p| p["id"] }
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

    def by_issue_id_query
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