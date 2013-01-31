require 'ostruct'

# Phase = Struct.new(:ticket, :who) do
class Phase < Struct.new(:ticket, :who)
  def add params
    self.ticket = params[:ticket]
    self.who = params[:who]
  end
end

# PhasesData = Struct.new(:qa1, :qa2) do
# class PhasesData < Struct.new(:qa1, :qa2) # user ostruct then check if param is in const array
class PhaseData < OpenStruct.new(:qa1)
  PHASE_TYPES = %w{qa1 qa2 qa3 qa4 ready staging1 staging2 live}.map(&:to_sym)

  def initialize
    # @phase = Phase.new
    # self.qa1 = Phase.new
    # PHASE_TYPES.each {|p| instance_variable_set("@#{p}", Phase.new) }
  end

  def add
  end
end


class Phases
  PHASE_TYPES = %w{qa1 qa2 qa3 qa4 ready staging1 staging2 live}.map(&:to_sym)
  PHASE_FIELDS = %w{ticket who}.map(&:to_sym)

  def self.valid?(params = {})
    # res = REQUIRED.each { |k| ({missing: k}) unless params.has_key? k.to_s }
    hash = {}
    hash[:missing] = []
    hash[:missing].push(:phase) unless params.has_key? 'phase'
    hash[:missing].push(:ticket) unless params.has_key? 'ticket'
    return hash unless hash[:missing].empty?
    return {invalid: :phase, data: params['phase']} unless self.class.valid_phase_name?(params['phase'])
    return {invalid: :ticket, data: nil} if params['ticket'].nil?
    # return {invalid: :ticket, data: params['ticket']} unless params['ticket'].to_i > 0 && params['ticket'].to_i << 100000000
    {}
  end

  def initialize
    # tree_block = lambda{|h,k| h[k] = [Hash.new(&tree_block)] }
    # @phases = Hash.new(&tree_block)
    # @phases = {}
    # PHASE_TYPES.each {|p| @phases[p] = [] }
    @phases = PhasesData.new
  end

  def [](phase_name)
    return unless self.class.valid_phase_name?(phase_name)
    # return [create] if @phases[phase_name].count == 0
    @phases[phase_name]
  end
  # def []=(phase_name)
  # end

  def size phase
    @phase[phase].size
  end

  def to_s
    hash = {}
    PHASE_TYPES.each {|p| hash[p] = [] }
    @phases.each do |phase, info|
      info.each { |fields| hash[phase] << fields }
      # hash[phase] << create if info.empty? #&& use_defaults?
    end
    hash.to_s
  end

  def to_hash
    hash = {}
    # instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    # self.attributes.each { |k,v| hash[k] = v }
    hash
  end

  def add phase, ticket, who
    return unless self.class.valid_phase_name?(phase)
    @phases[phase.to_sym].each { |a| return if a[:ticket] == ticket }
    @phases[phase.to_sym] << create(ticket, who)
  end

  def delete phase, ticket
    return unless self.class.valid_phase_name?(phase)
    @phases[phase.to_sym].delete_if {|a| a[:ticket] == ticket }
  end

  private
  def create ticket = '-', who = '-'
    {ticket: ticket, who: who}
  end

  def self.valid_phase_name?(phase)
    PHASE_TYPES.include?(phase.to_sym) ? true : false
  end
end


__END__

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


    REQUIRED_KEYS = [:phase, :ticket, :who]
    def valid_request? params, add = true
      # f = REQUIRED_KEYS.all? { |required| params.include?(required.to_s) }
      # return unless f
      # param_keys = params.keys.map {|k| k.downcase.to_sym }
      # REQUIRED_KEYS.each {|k| return {missing: k}.to_json unless param_keys.has_key? k }


    # data = request.env['rack.request.query_hash']
    # session.merge!(params)
    # s = eval(session.inspect)

