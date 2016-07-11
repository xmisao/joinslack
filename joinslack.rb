require 'net/http'
require 'pp'
require 'json'
require 'optparse'
require 'webrick'
require 'erb'

class InviteResult
  attr_accessor :response

  def initialize(response)
    @response = response
  end

  def succeeded?
    ok? == true
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
    fields = {:succeeded? => succeeded?, :status => status, :ok? => ok?, :error => error}.to_a.map{|elm| "#{elm[0]}=#{elm[1].inspect}"}.join(', ')
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

def start_server(team, token)
  srv = WEBrick::HTTPServer.new({
    :BindAddress => '0.0.0.0',
    :Port => 8080})

  path = File.expand_path(File.dirname($0)) + '/htdocs/'

  srv.mount_proc('/'){|req, res|
    erb = ERB.new(open(path + 'index.erb'){|f| f.read})
    res.body << erb.result(binding)
  }

  srv.mount_proc('/invite'){|req, res|
    email = req.query['email']
    result = invite(team, email, token)

    message = result.succeeded? ? "Succeeded to invite #{email} !" : "Failed to invite #{email} ..."

    erb = ERB.new(open(path + 'invite.erb'){|f| f.read})
    res.body << erb.result(binding)
  }

  Signal.trap(:INT){ srv.shutdown }

  srv.start
end

OPTS = {}

opt = OptionParser.new
opt.on('--team TEAM'){|v| OPTS[:team] = v}
opt.on('--email EMAIL'){|v| OPTS[:email] = v}
opt.on('--token TOKEN'){|v| OPTS[:token] = v}
opt.on('--serve'){|v| OPTS[:serve] = true}

opt.parse(ARGV)

if OPTS[:serve]
  start_server(OPTS[:team], OPTS[:token])
else
  result = invite(OPTS[:team], OPTS[:email], OPTS[:token])
  p result
end
