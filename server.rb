require "sinatra/base"
require 'json'
require 'logger'
require './phase'

@@phase = Phase.new

class Server < Sinatra::Base
  configure :production, :development do
    enable :logging
    # $logger = Logger.new(STDOUT)
    # enable  :sessions, :logging
  end

  before { logger.level = Logger::DEBUG }
  # before { env['rack.logger'] = Logger.new("log/sinatra.log", "a+")  }
  # before { env['rack.errors'] = '~/app.error.log'  }

  REQUIRED_KEYS = [:host, :ticket, :who]
  helpers do
    def valid_request? params
      # f = REQUIRED_KEYS.all? { |required| params.include?(required.to_s) }
      # return unless f
      # param_keys = params.keys.map {|k| k.downcase.to_sym }
      # REQUIRED_KEYS.each {|k| return {missing: k}.to_json unless param_keys.has_key? k }
      return {missing: 'host'}.to_json unless params.has_key? 'host'
      return {missing: 'ticket'}.to_json unless params.has_key? 'ticket'
      return {missing: 'who'}.to_json unless params.has_key? 'who'
      true
    end
  end

  get '/update/?' do
    content_type :json
    params = request.env['rack.request.query_hash']

    valid = valid_request? params
    return valid unless valid == true

    @@phase.update params['host'], params['ticket'], params['who']
    @@phase.data.to_json
  end

  get '/?.?:format?' do
    if params[:format] == 'json'
      content_type 'application/json'
      @@phase.data.to_json
    else
      @data = @@phase.data
      erb :status #, :locals => Test.data
    end
  end

  get '/_info' do
    <<-ENDRESPONSE
      Ruby:    #{RUBY_VERSION}
      Rack:    #{Rack::VERSION}
      Sinatra: #{Sinatra::VERSION}
      #{session.inspect}
    ENDRESPONSE
  end
end
