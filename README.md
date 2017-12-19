# README

## <a name="about"></a>fitnotify

This is a simple webhook meant to be run in cron to periodically notify a slack channel of upcoming
Strava club group events.

## Table of Contents

- [About](#about)
- [Using](#using)
- [Issues](#issues)
- [License](#license)

## <a name="using"></a>Using fitnotify

* Clone this repository.
* you will need the following environment variables set:
  * `STRAVA_CLUB_ID` - The ID of your Strava Club. Find it on https://www.strava.com
  * `STRAVA_API_TOKEN` - Your Strava app's API token. You will have to register an app on https://developers.strava.com first
  * `STRAVA_API_ENDPOINT` - Not necessary unless you are using an endpoint other than https://www.strava.com/api/v3
  * `DISPLAY_TIMEZONE` - Your timezone. It defaults to `Central Time (US & Canada)`
  * `SLACK_WEBHOOK_URL` - The full webhook URL for your slack channel. You will need to set up the Incoming WebHooks integration for this first at https://YOURSLACK.slack.com/apps/manage/custom-integrations
  * `OPEN_WEATHER_API_KEY` - API Key from Open Weather, http://openweather.org/api
  * `OPEN_WEATHER_CITY_ID` - The city code as used by the Open Weather API. Find it by searching for your city on http://openweather.org/city and getting the numeric code.
* Run `bundle` to install the required gems
* Then you can run the ruby script as is, or setup in cron. A simple cron job might look like this:

```
0 10 * * 1,3 cd /Users/yourname/src/fitnotify && SLACK_WEBHOOK_URL=webhook_url STRAVA_CLUB_ID=12345 STRAVA_API_TOKEN=abc123 OPEN_WEATHER_API_KEY=abc123 OPEN_WEATHER_CITY_ID=4544349 /Users/yourname/.rvm/wrappers/fitnotify/ruby /Users/yourname/src/fitnotify/notify-event.rb
```

### <a name="issues"></a>Issues
* For bugs or feature requests, [submit an issue](https://github.com/bratta/fitnotify/issues) via Github.
* If you would like to contribute code, please feel free to [send pull requests](https://github.com/bratta/fitnotify/pulls)
  for existing issues or features you would like to see. If
  they fit with the general philosophy of the application, don't break
  the app, and tests pass, they will likely be approved.

## <a name="license"></a>License

The MIT License

Copyright 2017 Tim Gourley

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
