# Sentry <=> Notion integration

This is a simple app that allows easy integration of Sentry with Notion.
The app allows Sentry to create tickets as pages inside a given Notion database.

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
6. Now if you haven't done so already, fork this repo. Open the `create_page.rb` and the `update_page.rb` files, and customize the name of the fields as they appear in your database.
By default, these are set to what I personnaly use in my backlog DB that looks like this :
