require "http"
require_relative './sidekiq'
require_relative './base'
require_relative '../notion'

class ResolveIssuesJob < Base
  def perform
    issue_ids = get_done_issues
    issue_ids.each { |issue_id| update_issue(issue_id) }
  end

  private

  def notion_request
    Notion::Base.new
  end

  def get_done_issues
    pages = notion_request.get_pages(by_status_query)
    pages["results"].select{ |p| Date.iso8601(p["last_edited_time"]) >= (Date.today - 1) }.map { |p| p["properties"]["issue_id"]["rich_text"][0]["plain_text"] }
  end

  def by_status_query
    {
      filter: {
        and: [
          {
            property: notion_request.status_property,
            select: {
              equals: notion_request.status_value
            }
          },
          {
            property: notion_request.category_property,
            select: {
              equals: notion_request.category_value
            }
          }
        ]
      }
    }
  end

  def update_issue(issue_id)
    p HTTP.headers("accept" => "application/json")
        .auth("Bearer #{ENV["SENTRY_TOKEN"]}")
        .put(
          "https://sentry.io/api/0/issues/#{issue_id}/",
          json: { status: "resolved" }
        )
  end
end