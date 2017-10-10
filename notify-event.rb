#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'active_support/time'

class StravaClubApi
  attr_accessor :club_id, :api_token, :api_url, :timezone

  def initialize(club_id, api_token, api_url, timezone)
    @club_id   = club_id   || abort("Missing STRAVA_CLUB_ID")
    @api_token = api_token || abort("Missing STRAVA_API_TOKEN")
    @api_url   = (api_url  || "https://www.strava.com/api/v3").chomp('/')
    @timezone  = timezone  || "Central Time (US & Canada)"
  end

  def get_api_response(uri_path)
    uri_path.sub!(/^\//, "")
    uri = URI.parse("#{@api_url}/#{uri_path}")
    begin
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new uri
        request['Authorization'] = "Bearer #{@api_token}"
        http.request request
      end
    rescue Exception => e
      abort("Error contacting Strava API: #{e}")
    end
  end

  def get_upcoming_events()
    response = get_api_response("/clubs/#{@club_id}/group_events?upcoming=true")
    return [JSON.parse(response.body)].flatten if response.code == "200"
    abort("Error from the API: #{response.message}")
  end

  def upcoming_events()
    [].tap do |formatted|
      events = get_upcoming_events()
      events.each do |event|
        event_url = "https://www.strava.com/clubs/#{@club_id}/group_events/#{event["id"]}"
        event_date = Time.parse(event["upcoming_occurrences"].first).in_time_zone(@timezone).strftime("%m/%d/%Y at %I:%M%P")
        formatted.push("Upcoming event: #{event["title"]} (#{event_date}): <#{event_url}|Event Details>")
      end
    end
  end
end

class SlackWebhook
  attr_accessor :webhook_url

  def initialize(webhook_url)
    @webhook_url = webhook_url || abort("Missing SLACK_WEBHOOK_URL")
  end

  def post(msg)
    payload = {text: msg}.to_json
    uri = URI.parse(@webhook_url)
    begin
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Post.new uri
        request.set_form_data('payload' => payload, 'username' => 'strava-bot', 'icon_emoji' => ':athletic_shoe:')
        http.request request
      end
    rescue Exception => e
      abort("Error contacting Slack API: #{e}")
    end
  end
end

strava = StravaClubApi.new(ENV['STRAVA_CLUB_ID'],
                           ENV['STRAVA_API_TOKEN'],
                           ENV['STRAVA_API_ENDPOINT'],
                           ENV['DISPLAY_TIMEZONE'])
slack = SlackWebhook.new(ENV['SLACK_WEBHOOK_URL'])

strava.upcoming_events().each do |event|
  slack.post(event)
end
