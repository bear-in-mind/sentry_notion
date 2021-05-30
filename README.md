# Sentry <=> Notion integration

A simple app built with [Roda](https://github.com/jeremyevans/roda) that allows basic integration between Sentry and Notion. Once deployed and configured, each new Sentry issue will trigger a page insertion in the Notion database of your choice, while solving an issue will mark the ticket as done.

*TODO : Tickets marked as done inside of Notion will sync back to Sentry every 5 minutes to mark the corresponding issues as solved.*

## Use

1. In Sentry, inside `Settings`, head to `Developer Settings`. You can then add a `New Internal Integration`.
Leave the webhook URL empty for now (it will be your future production URL), but fill out a name, allow `Issues and Events` with `Read and Write` and check the `issues` in the webhooks section.
Grab your token and your client secret
2. Head to https://www.notion.so/my-integrations
3. Add your new (internal) integration and note your Client secret.
4. Now in Notion, go to your target database. Hit the `Share` button, click on the field to add someone, and you'll see your integration appear in the list.
5. Now, click on the `Copy link` button, paste the link somewhere and extract the database id like so :
```
https://www.notion.so/myworkspace/a8aec43384f447ed84390e8e42c2e089?v=...
                                  |--------- Database ID --------|
```
6. Now if you haven't done so already, fork this repo. Open the `create_page.rb` and the `update_page.rb` files, and change the value of the variables accprding to the fields you actually use in your database. By default, these are set to what I personally use in my backlog DB that looks like this :
<img width="500" alt="board_view" src="https://user-images.githubusercontent.com/38864576/120089450-c1295300-c0fa-11eb-8813-c9f94a32aa85.png">
<img width="500" alt="ticket_example" src="https://user-images.githubusercontent.com/38864576/120089452-c4bcda00-c0fa-11eb-9ae5-78dc37f882b4.png">
7. Deploy in production, and set the following environment variables : `SENTRY_SECRET`, `SENTRY_TOKEN`, `NOTION_SECRET`, `NOTION_DB`.

8. Back to Sentry, go to your integration and set the Webhook URL to `https://your-app.com/issues`.
9. Create an alert rule in Sentry's Alerts section, choosing your own integration, and leaving filters blank
10. Check out your bugs appear and disappear 🦟
<img width="500" alt="Capture d’écran 2021-05-30 à 04 03 07" src="https://user-images.githubusercontent.com/38864576/120089556-f2565300-c0fb-11eb-878d-d7b3697f855c.png">

## Development

To run the server, run `rerun rackup`

To be able to route Sentry's webhook to your localhost, you'll need something like https://webhookrelay.com/ to run alongside your server. You'll also have to either add a new Sentry Integration with the webhookrelay URL as `Webhook URL`, or temporarily change the one in your current integration.

Add your environment variables in a `.env.rb` file like so :
```ruby
ENV["SENTRY_TOKEN"] = "YOUR_TOKEN_HERE"
ENV["SENTRY_SECRET"] = "YOUR_SECRET_HERE"
ENV["NOTION_SECRET"] = "NOTION_SUPER_SECRET_TOKEN"
ENV["NOTION_DB"] = "NOTION_DB_ID"
```

## Resources
https://roda.jeremyevans.net/
https://fiachetti.gitlab.io/mastering-roda/
https://developers.notion.com/docs
https://docs.sentry.io/api/
