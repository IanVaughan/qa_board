require "sinatra/base"
require 'json'
require 'logger'
require './lib/phases'

@@phase = Phases.new

class Server < Sinatra::Base

  configure :production, :development do
    enable :logging
  end

  helpers do
    REQUIRED = [:phase, :ticket]
    def valid_request? params
      # res = REQUIRED.each { |k| ({missing: k}) unless params.has_key? k.to_s }
      hash = {}
      return {missing: 'phase'}.to_json unless params.has_key? 'phase'
      return {missing: 'ticket'}.to_json unless params.has_key? 'ticket'
      return {invalid: 'ticket', data: nil}.to_json if params['ticket'].nil?
      return {invalid: 'ticket', data: params['ticket']}.to_json unless params['ticket'].to_i > 0 && params['ticket'].to_i << 100000000
      true
    end

    def render_text_board
      text = ''
      @@phase.data.each do |phase, details|
        text << render_text(phase)
        text << "\n"
      end
      text
    end

    def render_text phase
      text = "#{phase.to_s} | "
      @@phase.data[phase.to_sym].each {|d| text << d[:ticket] + " => " + d[:who] + " | " }
      text
    end
  end

  get '/?.?:format?' do
    if params[:format] == 'json'
      content_type 'application/json'
      @@phase.data.to_json
    elsif params[:format] == 'text'
      content_type "text/plain"
      render_text_board
    else
      erb :status, :locals => {phases: @@phase}
    end
  end

  # add/assign/remove/rm
  post %r{/(add|assign|remove|rm)/?.?(json|text)?} do |action, format|
    logger.info "#{action.inspect}, #{format.inspect} => #{params.inspect}"
    logger.info params[:captures].first

    unless (error_text = valid_request?(params)) == true
      return [400, error_text]
    end

    phase = params['phase']
    ticket = params['ticket']
    who = params['who'] || "-"

    case action
    when 'add','assign'
      @@phase.add(phase, ticket, who)
    when 'remove', 'rm'
      @@phase.delete(phase, ticket)
    end

    case format
    when 'json'
      content_type :json
      @@phase.data.to_json
    when 'text'
      content_type :text # "text/plain"
      render_text(params['phase'])
    else
      erb :status, :locals => {phases: @@phase}
    end
  end

  # get '/edit' do
  #   # add edit fields and submit/post
  # end

  get '/help' do
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
