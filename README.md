# Feedex

Simple RSS Aggregator

- multi-user
- periodic feed sync
- web-ui

## System requirements

- Ubuntu Host running 20.04
- SystemD
- Postgres (user/pass = postgres/postgres)

## Installing Development

To start your Phoenix server:

  * Setup the project with `mix setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4070`](http://localhost:4070) from your browser.

## Running Tests

    > MIX_ENV=test mix do compile, ecto.create, ecto.migrate
    > mix test
    > mix test.watch

## Installing Production

- Clone the repo
- Install assets
    > cd apps/feedex_ui/assets
    > npm install
    > npm run deploy
    > cd ../../..
- Setup Release
    > MIX_ENV=prod mix do phx.digest
    > MIX_ENV=prod mix do deps.get, ecto.create, ecto.setup, distillery.release
- Start the release
- Browse to `locahost:5070`

## Using SystemD

Create the database and run the migrations.  Then:

- edit the SystemD service file in `rel/feedex.service`
- `sudo cp rel/feedex.service /etc/systemd/system`
- `sudo chmod 644 /etc/systemd/system/feedex.service`

Start the service with SystemD

- `sudo systemctl start feedex`
- `sudo systemctl status feedex`
- `sudo systemctl restart feedex`
- `sudo systemctl stop feedex`
- `sudo journalctl -u feedex -f`

Make sure your service starts when the system reboots

- `sudo systemctl enable feedex`

Reboot and test!

![](https://badger.casmacc.net/png0/7162d8?path=NA)
