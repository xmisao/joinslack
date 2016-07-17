# joinslack

Send invite to EMAIL to join TEAM on slack. TOKEN is your test token.

## Usage(CLI)

~~~~
ruby joinslack.rb --team TEAM --email EMAIL --token TOKEN
~~~~

## Usage(Web)

If you use `--serve` option, start up WEBrick web server on port 8080.
Open `http://127.0.0.1:8080/` using your web browser.

~~~~
ruby joinslack.rb --serve --team TEAM --token TOKEN
~~~~
