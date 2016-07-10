require 'net/http'
require 'pp'
require 'json'
require 'optparse'

class InviteResult
  attr_accessor :response

  def initialize(response)
    @response = response
  end

  def ok?
    JSON.parse(@response.body)['ok']
  end

  def status
    @response.code.to_i
  end

  def error
    JSON.parse(@response.body)['error']
  end

  def inspect
    fields = {:status => status, :ok? => ok?, :error => error}.to_a.map{|elm| "#{elm[0]}=#{elm[1].inspect}"}.join(', ')
    "<#{self.class}: #{fields}>"
  end
end

def invite(team, email, token)
  url = "https://#{team}.slack.com/api/users.admin.invite"

  data = {
    'email' => email,
    'token' => token,
    'set_active' => 'true'
  }

  InviteResult.new(Net::HTTP.post_form(URI.parse(url), data))
end

OPTS = {}

opt = OptionParser.new
opt.on('--team TEAM'){|v| OPTS[:team] = v}
opt.on('--email EMAIL'){|v| OPTS[:email] = v}
opt.on('--token TOKEN'){|v| OPTS[:token] = v}
opt.on('--serve'){|v| OPTS[:serve] = true}

opt.parse(ARGV)

if OPTS[:serve]
  raise 'not implemented'
else
  result = invite(OPTS[:team], OPTS[:email], OPTS[:token])
  p result
end
