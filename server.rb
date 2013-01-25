require "sinatra/base"
require 'json'
# require 'shotgun'
require 'logger'

class Server < Sinatra::Base
  configure :production, :development do
    enable :logging
    # $logger = Logger.new(STDOUT)
    # enable  :sessions, :logging
  end

  before { logger.level = Logger::DEBUG }
  # before { env['rack.logger'] = Logger.new("log/sinatra.log", "a+")  }
  # before { env['rack.errors'] = '~/app.error.log'  }

  # set :sessions, true # is this client side?

  HOSTS = %w{QA1 QA2 QA3 QA4 Staging1 Staging2 Production} #symbols?
  FIELDS = %w{ticket tester}

  REQUIRED_KEYS = [:host, :ticket, :who]
  get '/update' do # post type type must be json
    content_type :json # content_type 'application/json'
    params = request.env['rack.request.query_hash']
    # logger.debug "/update #{params.inspect}"
    # logger.debug "/update #{REQUIRED_KEYS.inspect}"

    # f = REQUIRED_KEYS.all? { |required| params.include?(required.to_s) }
    # logger.debug "/update f:#{f}"
    # return unless f
    return unless params.has_key? 'host'
    return unless params.has_key? 'ticket'
    return unless params.has_key? 'who'
    # logger.debug "/update - updating : #{params['host']}, #{params['ticket']}, #{params['who']}"

    Test.update params['host'], params['ticket'], params['who']
    Test.data.to_json
  end

  # get '/update/:host/:ticket/:who' do |host, ticket, who| # post/put/patch?
  #   logger.debug "/update/:host/:ticket/ #{params.inspect}"
  #   content_type 'application/json'
  #   # post type type must be json
  #   logger.debug "#{host}, #{ticket}, #{who}"
  #   Test.update host, ticket, who
  #   Test.data.to_json
  # end

  get '/.?:format?' do
    logger.debug "/ #{params.inspect}"
    if params[:format] == 'json'
      content_type 'application/json'
      Test.data.to_json
    else
      @data = Test.data
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

class Test
  @data = {
    :QA1 => {:ticket => 1, :tester => "Me"},
    :QA2 => {:ticket => 5678, :tester => "You"}
  }

  def self.data
    @data
  end

  def self.update host, ticket, who
    return unless @data.has_key? host.to_sym
    @data[host.to_sym] = {:ticket => ticket, :tester => who}
  end
end
