require 'ostruct'

class Phases
  PHASE_TYPES = %w{qa1 qa2 qa3 qa4 ready staging1 staging2 live}.map(&:to_sym)
  PHASE_FIELDS = %w{ticket who}.map(&:to_sym)

  def initialize
    @phases = {}
    PHASE_TYPES.each {|p| @phases[p] = [create] }
  end

  def queue_size phase
    # puts @phases.inspect
    return 0 if @phases[phase.to_sym].count == 1 && @phases[phase.to_sym][0][:ticket] == '-'
    @phases[phase.to_sym].count
  end

  def data
    hash = {}
    PHASE_TYPES.each {|p| hash[p] = [] } #Array.new(1) { create('-', '-') } }
    @phases.each {|phase, d| d.each { |t| hash[phase] << t } } #.marshal_dump
    hash
  end

  def add phase, ticket, who
    return unless valid_phase_name?(phase)
    @phases[phase.to_sym].delete_at(0) if queue_size(phase) == 0
    @phases[phase.to_sym] << create(ticket, who)
  end

  def delete phase, ticket
    return unless valid_phase_name?(phase)
    @phases[phase.to_sym].delete_if {|a| a[:ticket] == ticket }
    @phases[phase.to_sym] << create if queue_size(phase) == 0
  end

  private
  def create ticket = '-', who = '-'
    # OpenStruct.new(ticket: ticket, who: who)
    {ticket: ticket, who: who}
  end

  def valid_phase_name?(phase)
    PHASE_TYPES.include?(phase.to_sym) ? true : false
  end

end
