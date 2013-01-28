require "sinatra/base"
require 'json'
require 'logger'
require './lib/phases'

@@phase = Phases.new

class Server < Sinatra::Base

  helpers do
    def valid_request? params
      return {missing: 'phase'}.to_json unless params.has_key? 'phase'
      return {missing: 'ticket'}.to_json unless params.has_key? 'ticket'
      true
    end

    def render_text_board
      text = ''
      @@phase.data.each do |phase, details|
        text << phase.to_s + " | "
        text << render_text(phase)
        text << "\n"
      end
      text
    end

    def render_text phase
      text = ""
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

  post '/add/?.?:format?' do
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
