require "sinatra/base"
require 'json'
require 'logger'
require './lib/phases'

@@phase = Phases.new

class Server < Sinatra::Base

  # set :sessions, true
  # set :logging
  # set :variable,"value" #erb: #{settings.variable}"
  configure :production, :development do
    enable :logging
    # $logger = Logger.new(STDOUT)
    # enable  :sessions, :logging
    # use Rack::Session::Pool
  end

  before { logger.level = Logger::DEBUG }
  # before { session['phases'] ||= Phase.new(logger) }
  # before { env['rack.logger'] = Logger.new("log/sinatra.log", "a+")  }
  # before { env['rack.errors'] = '~/app.error.log'  }

  helpers do
    REQUIRED_KEYS = [:phase, :ticket, :who]
    def valid_request? params, add = true
      # f = REQUIRED_KEYS.all? { |required| params.include?(required.to_s) }
      # return unless f
      # param_keys = params.keys.map {|k| k.downcase.to_sym }
      # REQUIRED_KEYS.each {|k| return {missing: k}.to_json unless param_keys.has_key? k }
      return {missing: 'phase'}.to_json unless params.has_key? 'phase'
      return {missing: 'ticket'}.to_json unless params.has_key? 'ticket'
      return true unless add
      return {missing: 'who'}.to_json unless params.has_key? 'who'
      true
    end

    def render_text
      text = ''
      @@phase.data.each do |phase, details|
        text << phase.to_s + " | "
        details.each {|d| text << d[:ticket] + " => " + d[:who] + " | " }
        text << "\n"
      end
      text
    end
  end

  get '/?.?:format?' do
    if params[:format] == 'json'
      content_type 'application/json'
      @@phase.data.to_json
    elsif params[:format] == 'text'
      render_text
    else
      erb :status, :locals => {phases: @@phase}
    end
  end

  post '/add/?.?:format?' do
    # data = request.env['rack.request.query_hash']
    # session.merge!(params)
    # s = eval(session.inspect)

    unless (error_text = valid_request?(params)) == true
      return error_text
    end

    @@phase.add(params['phase'], params['ticket'], params['who'])

    if params[:format] == 'json'
      content_type :json
      @@phase.data.to_json
    elsif params[:format] == 'text'
      render_text
    else
      erb :status, :locals => {phases: @@phase}
    end
  end

  post '/remove/?.?:format?' do
    invalid_text = valid_request?(params, false)
    return invalid_text unless invalid_text == true

    @@phase.delete(params['phase'], params['ticket'])

    if params[:format] == 'json'
      content_type :json
      @@phase.data.to_json
    elsif params[:format] == 'text'
      render_text
    else
      erb :status, :locals => {phases: @@phase}
    end
  end

  get '/edit' do
    # add edit fields and submit/post
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
