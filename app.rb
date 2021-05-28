require "roda"
require './.env' if File.exist?(".env.rb")
require_relative "./notion_request"

class App < Roda
  plugin :h
  plugin :json
  plugin :json_parser

  route do |r|
    r.post do
      r.is "issues" do
        params = issue_params(r)
        send_to_notion(params)
        params[:message]
      end
    end
  end

  private

  def issue_params(r)
    {
      message: r.params.dig("data", "issue", "title"),
      issue_id: r.params.dig("data", "issue", "id"),
      app_id: r.params.dig("data", "issue", "project", "id"),
      app_slug: r.params.dig("data", "issue", "project", "slug")
    }
  end

  def send_to_notion(params)
    request = NotionRequest.new(params)
    request.send
  end
end