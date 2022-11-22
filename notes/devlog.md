# Feedex Devlog

## Roadmap 

Feedx Features
- [x] Phoenix 1.7 rewrite 
- [x] Tailwind 
- [x] New component tooling with slots and attributes 
- [ ] User accounts / auth / email confirmation 
- [ ] Simultaneous login count 
- [ ] Metrics: prometheus, loki, tempo 
- [ ] Full-text search 
- [ ] Docker releases 
- [ ] Mobile interface 
- [ ] Vim-style Keyboard mode 
- [ ] Convert from PETS to CubDB

Basics 
- [ ] Finish layout 
- [ ] Generate docs 
- [ ] Convert to Feedex 
- [ ] Use in production 

Networking 
- [ ] Setup DNS, ssl, reverse-proxy on chap
- [ ] Selective Wireguard routing - only chap apps 
- [ ] Test with travel router and phone 

Cleanup 
- [ ] Get rid of Timex
- [ ] Get rid of Distillery

Fixes 
- [ ] JSON import/export stopwords

Features
- [ ] UI: Generate admin pages: users / feeds / posts 
- [ ] UI: Admin-links to Dashboard and Admin pages on settings page 
- [ ] UI: Admin-only access to admin pages 
- [ ] Infra: Restful API: RSS/JSON (Feeds and Folders) 
- [ ] Infra: Restful API: SyncNow (Feeds and Folders) 
- [ ] Infra: Restful API: Mark as Read (Feeds and Folders) 
- [ ] Infra: Webhook for each Feed and Channel 
- [ ] Infra: Metrics, Tracing (Jaeger), Logs (Loki) 
- [ ] Infra: Org & User, Permissions & Tokens, Login 
- [ ] Telemetry: Get grafana displays working 
- [ ] Telemetry: Get PromEx working 
- [ ] Telemetry: Number of logged-in users 
- [ ] Telemetry: Number of active sessions 

## 2019 Jul 27 Sat

- [x] Add feedex_web
- [x] Create feedex layout
- [x] Add feedex_client
- [x] Get feedex_client#get to return data
- [x] Get probe to work
- [x] Setup VCR for feedex_client
- [x] Setup VCR for feedex_client.url
- [x] Add feedex_core
- [x] Build first feedex_core tests
- [x] Add feedex_jobs

## 2019 Jul 30 Tue

- [x] Update FeedexCore migration
- [x] Take "Mastering SQL" course
- [x] Read Ecto Book 
- [x] Add ecto-data contexts

## 2019 Jul 31 Wed

- [x] Build Account schemas
- [x] Add tests for Account schemas
- [x] Build seed-data function
- [x] Build News schemas
- [x] Add tests for News schemas
- [x] Add factories for News schemas
- [x] Design UI
- [x] Design News Context
- [x] Design Account Context
- [x] Build Account Context
- [x] Test Account Context
- [x] Build News Context
- [x] Test News Context
- [x] Add FeedxJobs.scan(url)
- [x] Add FeedxJobs.update(url)
- [x] Add FeedexRunner
- [x] Add FeedexRunner.start()
- [x] Add FeedexRunner.stop()
- [x] Add FeedexRunner.config_show()
- [x] Add FeedexRunner.config_update()
- [x] Add News page
- [x] Update feedex nav

## 2019 Aug 01 Thu

- [x] Make sure we generate a pwd_hash in the factory
- [x] Add a clear script
- [x] Add Accounts.create_user
- [x] Add login / logout (Phoenix Book)
- [x] Add current_user (AuthPlug Phoenix Book)
- [x] Study testing

## 2019 Aug 02 Fri

- [x] LV - DO / Add second clock to demo page
- [x] LV - Basics / Router Rendering
- [x] LV - Basics / Controller Rendering (live_render)
- [x] LV - Basics / Tag Rendering (live_render)
- [x] LV - PSP / Using PubSub
- [x] LV - PSP / Using Channels
- [x] LV - Misc / What is `handle_info`?
- [x] Study LiveView

## 2019 Aug 03 Sat

- [x] Build LV PubSub demo
- [x] Change news to normal render

## 2019 Aug 07 Wed

- [x] Configure Webpack
- [x] Create `Live.News.Btn`
- [x] Create `Live.News.Tree`
- [x] Create `Live.News.Hdr`
- [x] Create `Live.News.Body`
- [x] Demo Nested Components
- [x] Demo Nested Component PubSub

## 2019 Aug 08 Thu

- [x] Add Pets
- [x] Define Pets testing process
- [x] Refactor Pets

## 2019 Aug 09 Fri

- [x] Add UI state
- [x] Build ShowUiState component
- [x] Add ShowUiState component to body

## 2019 Aug 10 Sat

- [x] Fix Pets config (testing)
- [x] Add Auth to news page

## 2019 Aug 11 Sun

- [x] Click Buttons to update UiState

## 2019 Aug 12 Mon

- [x] Create treemap query 
- [x] Add treemap to controller
- [x] Generate test tree data

## 2019 Aug 13 Tue

- [x] Add treemap to TREE/HDR/BODY
- [x] Display test trees in TREE/HDR/BODY
- [x] Click tree updates UIstate

## 2019 Aug 13 Wed

- [x] Ecto Testing

## 2019 Aug 30 Fri

- [x] HDR display: folder
- [x] HDR display: feed

## 2019 Sep 07 Sat

- [x] BASE: add scheme for caching UISTATE (uistate digest)
- [x] BASE: convert news to liveview
- [x] BODY display: folder
- [x] BODY display: feed
- [x] BODY display: all
- [x] Add view layout for editing folders and feedds

## 2019 Sep 08 Sun

Editing Design Notes:
- copy form technique from purlex
- a feed must be in a folder
- there always has to be one folder
- a folder can't be deleted if it contains a feed

- [x] Add Folder
- [x] Add Feed
- [x] Edit Folder
- [x] Edit Feed

## 2019 Sep 09 Mon

- [x] Setup seeds with real URLs
- [x] Create `FeedxJob.sync`
- [x] Import live posts
- [x] Add manual sync button for feed
- [x] VIEWING: View post
- [x] Posts: sort descending
- [x] Posts: toggle show/hide
- [x] Posts: add text link

## 2019 Sep 10 Tue

- [x] VIEWING: Update post-read status
- [x] VIEWING: Index the read_list

## 2019 Sep 11 Wed

- [x] QUERY: posts with read: true/false column by register
- [x] QUERY: posts with read: true/false column by folder
- [x] QUERY: posts with read: true/false column by all
- [x] VIEWING: Highlight unread rows
- [x] Sync now button
- [x] Periodic sync (quantum/cron)
- [x] Display update times (1m, 2h, 3d, 4w)
- [x] Refactor readlog
- [x] QUERY: count of unread by register
- [x] QUERY: count of unread by folder
- [x] QUERY: count of unread by all
- [x] Show unread counts in tree
- [x] Mark all (pst/reg/fld/all)
- [x] Sync all (pst/reg/fld/all)
- [x] Deploy production
- [x] Install systemD

## 2019 Sep 12 Thu

- [x] Admin: Delete folder
- [x] Add cascade deletes
- [x] Fix feed sync
- [x] Admin: Delete feed

## 2019 Sep 15 Sun

- [x] Write LiveEditable
- [x] Admin: Rename folder
- [x] Admin: Rename feed

## 2019 Sep 16 Mon

- [x] Add link to RSS url
- [x] Reverse Feed List before loading
- [x] No Links for active AddFolder
- [x] No Links for active AddFeed
- [x] Optimize Tree Query
- [x] Fix Broken Feeds (ExStatus, ExJobs)
- [x] Mobile: Fix Menu Dropdown
- [x] Mobile: Mobile Btn & Tree Divs

## 2019 Sep 17 Tue

- [x] Print: print record of feeds 
- [x] Fix uistate sync

## 2019 Sep 18 Wed

- [x] Configure public machine
- [x] Move system to public machine

## 2019 Sep 19 Thu

- [x] Add case-insensitive login
- [x] Add distinct post query
- [x] Add Ecto telemetry
- [x] Add Plug telemetry
- [x] Add VM telemetry
- [x] Export to Influx
- [x] Render in Grafana
- [x] Framework Events: Plug 
- [x] Framework Events: Ecto
- [x] VM Polling: Memory
- [x] VM Polling: TotalRunQueue

## 2019 Sep 20 Fri

- [x] Add Grafana Panel
- [x] Re-read LV Docco
- [x] Read LV Test Docs

## 2019 Sep 21 Sat

- [x] Fix LiveReload 
- [x] Add DataCase#count
- [x] Add DataCase#load_test_data
- [x] Add LV Seeds
- [x] Add LV Integration Tests (Hound)
- [x] Upgrade to LV 0.3.0
- [x] Add LV Unit Tests
- [x] LiveEditable: Add Select Function
- [x] Admin: Add FolderSelect for Feeds

## 2019 Sep 22 Sun

- [x] Metrics: posts by feed
- [x] Metrics: unread posts by feed

## 2019 Sep 22 Sun

- [x] Get unread count into header (all / folder / feed)
- [x] New header title: Folder > Feed [unread count]
- [x] Fix read highlight bug (bodyview)
- [x] Allcheck on mobile view
- [x] Add byline to post view

## 2019 Oct 21 Mon

- [x] stopwords: by account
- [x] stopwords: apply to folders (on/off - default off)

## 2019 Dec 11 Wed

- test runner is not working
- problem is with quantum scheduler (telemetry poller, jobs)

## 2021 Feb 08 Mon

- [x] add LiveView Dashboard
- [x] add FeedexCore
- [x] create FeedexTsdb
- [x] create FcRss
- [x] create FcHtml
- [x] Add AlpineJS

## 2021 Feb 09 Tue

- [x] Add Cyprus
- [x] Add FeedxJob

## 2021 Feb 10 Wed

Notes:
- Kaffy didn't work / proprietary DSL / proprietary / hard to customize
- Use torch / standard generators / transferrable skills / easy to customize
- Torch failed on umbrella project - practice on throwaway app

## 2021 Feb 12 Fri

- [x] FeedexWeb: Get Torch working on Standalone project
- [x] FeedexWeb: Add Torch to feedex (umbrella context)

Learnings:
- torch isn't that great
- direction: master the off-the-shelf generators

## 2021 Feb 14 Sun

- https://github.com/wintermeyer/phx_tailwind_generators
- works with standard Phoenix or Umbrellas
- initial setup: Fullstack Phoenix or manual config

## 2021 Feb 15 Mon

- generators work with umbrella projects
- there is a configuration for context app
- can be defined in the application config, or on the command line
- the context provides the API used by the web interface
- the schema interacts with the database
- liveview generator has a modal...

- [x] Study Channel generator
- [x] Study LiveView generator

## 2021 Feb 17 Wed

- [x] New umbrella project - binary ID
- [x] Add tailwind generators, phx.gen.auth
- [x] Comment out old contexts and migrations
- [x] Make sure we're using binary_id
- [x] Run phx.gen.auth
- [x] Replace old webapp with new
- [x] Setup context app in config
- [x] Restore migrations

## 2021 Feb 18 Thu

- [x] Study LiveNavigation
- [x] Study LiveComponents
- [x] Mock up Tailwind UI

## 2021 Feb 20 Sat

- [x] Create Tailwind Layout

## 2021 Feb 20 Sat

- [x] Restore objects and tests

## 2021 Feb 21 Sun

- [x] UI: clock as LiveComponent
- [x] UI: clock as LiveView
- [x] UI: add alpine

## 2021 Feb 22 Mon

- [x] FcHtml: Add HTTP Client Finch (finch telemetry elixir html)

## 2021 Feb 26 Fri

Recap:
- got LiveView book
- learned login technique
- discovered `phx.gen.live`

## 2021 Feb 27 Sat

- [x] UI: build out user login
- [x] LV: Pick up current_user
- [x] UI: ActiveLink
- [x] Style Menu

## 2021 Feb 28 Sun

- [x] Style Page: Login
- [x] Style Page: Register
- [x] Style Page: Settings
- [x] Remove phoenix.css
- [x] News: Add UI State
- [x] Get seed generation working with login 
- [x] Prototype components

## 2021 Mar 01 Mon

- [x] News: write base tree component
- [x] UI: test <Surface/> (fail)
- [x] News: write base header component

## 2021 Mar 02 Tue

- [x] Test FcRss connected to FcTesla
- [x] Feeds: get feeds working
- [x] Remove FcHttp
- [x] News: get feed counts working

## 2021 Mar 03 Wed

- [x] News: Fix layout (Grey Blocks)
- [x] News: Clean up unread counts
- [x] News: Add icons

## 2021 Mar 04 Thu

What is the best way for the tree to update the hdr/btn/body?
- [x] all DB interactions should be done in NewsLive
- [x] pass around uistate, treemap, counts
- [x] shared functions: icons, badges, etc.
- [x] add folder_id to treemap data structure
- [x] add Treemap util functions for Registry and Folder lookups
- [-] identify who is sending - update all the others

Goal: reduce the number of database queries in the life-cycle

- [x] News: Fix unread count on header

## 2021 Mar 08 Mon

- [x] Cleanup functions and write tests
- [x] Eliminate unneeded DB lookups
- [x] News: write base body component
- [x] BTN: Folder Link
- [x] BTN: Feed Link
- [x] TREE/HDR/BTN - Link Style
- [x] HDR: Folder Link
- [x] BodyView: Smaller display font
- [x] Tree: Folder Link
- [x] Tree: Reg Link

## 2021 Mar 09 Tue

- [x] BodyView: Article Display
- [x] HDR: Mark all Read Button
- [x] HDR: Mark all Read Link Generation
- [x] HDR: Mark all Read Handlers
- [x] BodyView: Broadcast 'mark read' on view
- [x] IconHelper: Add check_svg
- [x] BodyView: Show read checkmark
- [x] Create Folder
- [x] Header Buttons
- [x] Header link / refresh
- [x] Header link / edit
- [x] Header link / sync
- [x] Create Feed
- [x] Edit Folder
- [x] Edit Feed
- [x] FeedxJob: Get cron working...
- [x] Settings: Subscription Display (text)
- [x] Remove archive code
- [x] Merge to Dev

## 2021 Mar 10 Wed

- [x] Settings: Subscription Display (json)
- [x] FeedexCore: Create API calls for feeds and folders

## 2021 Mar 11 Thu

- [x] API.SubTree functions to Load Subscriptions (data)
- [x] API.SubTree functions to Load Subscriptions (json)
- [x] Refactor "CreateFeed" Liveview page to use API.SubTree
- [x] LiveView page to upload Subscription Json

## 2021 Mar 14 Sun

- [x] Use locally
- [x] Fix NewsLive Page Updates

## 2021 Mar 15 Mon

- [x] Update display upon loading new docs
- [x] Install Twilwind JIT Compiler

## 2021 Mar 17 Wed

- [x] Study LiveDashboard Styling
- [x] Study Surface Demo Site
- [x] Fix LiveEditable for Tailwind

## 2021 Mar 24 Wed

- [x] Change feedex_core to feedex_core
- [x] Convert from Tailwind to Bootstrap

## 2021 Mar 25 Thu

- [x] Restyle navbar with BootstrapCSS
- [x] Add Bootstrap Icons
- [x] Restyle news page with BootstrapCSS
- [x] Merge to dev
- [x] Cleanup Bootstrap Responsive classes (desktop-only, mobile-only - sass alias?)

## 2021 Mar 26 Fri

- [x] Enable target options: "use Phonix.LiveEditable, target: @myself"

## 2021 Mar 27 Sat

- [x] Use new LiveEditable on folder edit pages
- [x] Use new LiveEditable on feed edit pages
- [x] Deploy to staging

## 2021 Apr 03 Sat

- [x] Copy feeds to staging
- [x] Clickable tree folder while in edit mode
- [x] Clickable tree feed while in edit mode
- [x] Fix "delete feed"
- [x] Fix "delete folder"
- [x] Deploy to staging
- [x] Update feeds
- [x] Add-folder needs to refresh display
- [x] Add-feed needs to refresh display
- [x] Enable refresh button
- [x] Edit folder stopwords
- [x] Update dependencies
- [x] Settings link to dashboard page
- [x] Enable all dashboard options
- [x] Enable dashboard for production

## 2021 Apr 04 Sun

- [x] Telemetry: Get polling writers working (influx)
- [x] Get rid of compiler warnings

## 2021 Apr 05 Mon

- [x] create `jobex_telemetry` app

## 2021 Apr 08 Thu

- [x] Telemetry: Enable built-in telemetry (ecto)
- [x] Telemetry: Enable built-in telemetry (system)
- [x] Telemetry: Enable built-in telemetry (phoenix)
- [x] Telemetry: Enable built-in telemetry (tesla)
- [x] Telemetry: Enable built-in telemetry (liveview)
- [x] Telemetry: Study Elixir Metrics Infrastructure
- [x] Telemetry: Convert the polling writer to a telemetry generator
- [x] Telemetry: Clean up current metrics writers

## 2021 May 20 Thu

- [x] Upgrade to Elixir 1.12-otp24

## 2021 May 21 Fri

- [x] Fix Tesla RSS Client
- [x] Move PubSub to apps/feedex
- [x] Deploy on staging
- [x] Change to purple favicon
- [x] Change from FeedexUi to Feedex
- [x] Merge to master
- [x] Update staging
- [x] Upgrade pubhost to 1.12

## 2021 May 22 Sat

- [x] Deploy on pubhost
- [x] Shut down staging

## 2022 Nov 16 Wed

Objectives 
- Upgrade to Phx 1.7
- Upgrade to LiveView 1.18
- Convert CSS to Tailwind 

Notes
- Umbrella doesn't work with phx-1.7-rel0 
- Rewriting as normal phoenix app - no umbrella 

- [x] Bring over fc_finch library
- [x] Test/Src navigation 
- [x] Start fc_finch application 
- [x] View fc_finch app with :observer 
- [-] View fc_finch app with dashboard 
- [x] Test fc_finch 
- [x] Use FcFinch.get in iex 
- [x] Bring over api 
- [x] Export feeds 

## 2022 Nov 17 Thu

- [x] Try `getch` fix 
- [x] Restart test runner 
- [x] Import feeds 
- [x] Import production feed 
- [x] Bring over fc_tesla (dependency, code, test) 
- [x] Bring over fc_rss (dependency, code, test) 
- [x] Bring over feedex_job (dependency, code, test, application) 

## 2022 Nov 18 Fri

- [x] Build out the UI 
- [x] Fix LSP (Elixir / Dialyzer) 
- [x] Get Tree working clean 
- [x] Get favicon working 
- [x] Clean up header 

## 2022 Nov 19 Sat

- [x] Get broadcasts working 
- [x] Get Body working clean 
- [x] Remove `feedex_ui` directory 
- [x] Remove gap 
- [x] Show logo 
- [x] Show favicon 
- [x] Icon | Mark all 
- [x] Icon | Add Folder/Feed 
- [x] Icon | Refresh 
- [x] Icon | Edit (pencil) 
- [x] Display post 
- [x] Add Folder 
- [x] Add Feed 
- [x] Edit Folder 
- [x] Edit Feed 

## Next Steps 

- [ ] Get LiveEditable working 
