class Phases
  PHASE_TYPES = %w{qa1 qa2 qa3 qa4 ready staging1 staging2 live}.map(&:to_sym)
  PHASE_FIELDS = %w{ticket who}.map(&:to_sym)

  def initialize
    @phases = {}
    PHASE_TYPES.each {|p| @phases[p] = [] }
  end

  def queue_size phase
    return unless valid_phase_name?(phase)
    @phases[phase.to_sym].count
  end

  def data
    hash = {}
    PHASE_TYPES.each {|p| hash[p] = [] }
    @phases.each do |phase, info|
      info.each { |fields| hash[phase] << fields }
      hash[phase] << create if info.empty?
    end
    hash
  end

  def add phase, ticket, who
    return unless valid_phase_name?(phase)
    @phases[phase.to_sym] << create(ticket, who)
  end

  def delete phase, ticket
    return unless valid_phase_name?(phase)
    @phases[phase.to_sym].delete_if {|a| a[:ticket] == ticket }
  end

  private
  def create ticket = '-', who = '-'
    {ticket: ticket, who: who}
  end

  def valid_phase_name?(phase)
    PHASE_TYPES.include?(phase.to_sym) ? true : false
  end
end
