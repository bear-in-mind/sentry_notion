task :resolve_issues do
  require "./app"
  require "./jobs/resolve_issues_job"
  ResolveIssuesJob.perform_async_in_prod
end