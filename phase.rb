class Phase
  PHASES = (4.times.map {|x| "qa#{x+1}" } << %w{ready staging1 staging2 live}).flatten.map(&:to_sym)
  FIELDS = %w{ticket who}.map(&:to_sym)

  def initialize(logger = nil)
    logger = Logger.new('log/phase.log')
    # @logger = logger
    logger.debug "Phase.init"


    field_hash = {}
    FIELDS.each {|x| field_hash[x] = '-'}

    @phase = {}
    PHASES.each {|x| @phase[x] = field_hash.dup}
    @phase
  end

  def data
    @phase
  end

  def update host, ticket, who
    return unless @phase.has_key? host.to_sym
    @phase[host.to_sym] = {:ticket => ticket, :who => who}
  end

end
