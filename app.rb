require "roda"
require "./.env" if File.exist?(".env.rb")
require "./notion"

class App < Roda
  plugin :h
  plugin :json
  plugin :json_parser

  route do |r|
    r.post do
      r.is "issues" do
        params = issue_params(r)
        send_to_notion(params)
        params[:title]
      end
    end
  end

  private

  def issue_params(r)
    {
      title: "#{r.params.dig("data", "issue", "metadata", "type")}",
      message: r.params.dig("data", "issue", "metadata", "value"),
      issue_id: r.params.dig("data", "issue", "id"),
      app_id: r.params.dig("data", "issue", "project", "id"),
      app_slug: r.params.dig("data", "issue", "project", "slug"),
      action: r.params.dig("action")
    }
  end

  def send_to_notion(params)
    if params[:action] == "resolved"
      Notion::UpdatePage.new(params)
    else
      Notion::CreatePage.new(params)
    end
  end
end