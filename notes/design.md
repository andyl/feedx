# Feedex Design Notes

## Applications

| APP             | Generator                | Purpose                 |
|-----------------|--------------------------|-------------------------|
| x feedex_client | mix new feedex_client    | HTML Client - Reads RSS |
| x feedex_core   | new.phx.ecto feedex_core | Ecto Interface          |
| x feedex_tsdb   | mix new feedex_tsdb      | Time Series DB (Influx) |
| x feedex_job    | mix new feedex_job       | Scheduled RSS Sync Jobs |
| x feedex_web    | new.phx.web feedex_web   | Web UI                  |
| - feedex_term   | mix new feedex_term      | Terminal UI             |
| - feedex_api    | new.phx.web feedex_api   | GraphQL API             |

## Schema

User > Folder > Register < Feed < Post

ReadLog 

- ReadLog: one record for every read post 
- each ReadLog record contains: `id, user_id, folder_id, register_id, post_id`

Key API Calls:

- build tree with aggregate unread-count (register/folder/all)
- list posts with read-status (register/folder/all)
- mark as read (post/register/folder/all)
- sync feed (register/folder/all)

## 3rd-Party Tooling

| App          | Tool             | Purpose                  |
|--------------|------------------|--------------------------|
| FeedexClient | ElixirFeedParser | RSS Parsing              |
| FeedxJob    | Oban             | Background Job Runner    |
| FeedxJob    | Quantum          | Cron-like Job Scheduling |
| FeedexWeb    | LiveView         | Dynamic UI               |
| FeedexWeb    | Pets             | ETS Caching              |

## Persistence

FeedexCore uses Postgres with the standard Ecto tooling.

FeedexWeb caches UiState in ETS tables backed by files on disk. 

## UiState

Purpose:

- core to FeedexWeb LiveView
- backed by PersistentETS
- used by PushState

| Field  | Description | Type       |
|--------|-------------|------------|
| usr_id | User ID     | integer    |
| fld_id | Folder ID   | integer    |
| reg_id | Register ID | integer    |
| pst_id | Post ID     | integer    |
| mode   | UI MODE     | enumerated |

Valid Modes:
- view
- add_feed
- add_folder
- edit_feed
- edit_folder

Notes:
- nav tree always sorted alphabetically
- nav folders always open
- fld_id and reg_id can be blank - both can't be filled at once

## Ui PubSub

| Action                      | Event       | From      | To              |
|-----------------------------|-------------|-----------|-----------------|
| when post is viewed         | read_one    | bodyview  | tree            |
| when "read all" is pressed  | read_all    | hdr       | bodyview, tree  |
| when sync job updated       | read_all    | JobRunner | bodyview, tree  |
| when folder/feed is added   | tree_mod    | addui     | tree, body      |
| when folder/feed is removed | tree_mod    | remui     | tree, body      |
| when folder/feed is renamed | tree_mod    | editui    | tree, hdr       |
| clicking on btn             | set_uistate | btn       | hdr, tree, body |
| clicking on tree            | set_uistate | tree      | btn, hdr, body  |
| clicking on edit            | set_uistate | hdr       | btn, hdr, body  |
