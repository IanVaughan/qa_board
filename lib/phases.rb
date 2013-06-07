module PhaseControl
  extend self

  PHASE_TYPES = %w{qa1 qa2 qa3 qa4 ready staging1 staging2 live}.map(&:to_sym)
  PHASE_FIELDS = %w{ticket who}.map(&:to_sym)

  def phases
    @phases ||= begin
      h = {}
      PHASE_TYPES.each {|p| h[p] = [] }
      h
    end
  end

  def add phase, ticket, who
    return unless valid_phase_name?(phase)
    phases[phase.to_sym].each { |a| puts a; return if a[:ticket] == ticket }
    phases[phase.to_sym] << Role.new(ticket, who)
  end
  def delete phase, ticket
    return unless valid_phase_name?(phase)
    phases[phase.to_symvalid_phase_name].delete_if {|a| a[:ticket] == ticket }
  end

  def data
    hash = {}
    PHASE_TYPES.each {|p| hash[p] = [] }
    phases.each do |phase, info|
      info.each { |fields| hash[phase] << fields }
      hash[phase] << create if info.empty?
    end
    hash
  end

  def [](phase)
    phases[phase]
  end

  def valid_phase_name?(phase)
    PHASE_TYPES.include?(phase.to_sym) ? true : false
  end

  class Role
    attr_reader :ticket, :who

    def initialize(ticket, who)
      @ticket = ticket
      @who    = who
    end

    def to_s
      @ticket
    end
  end
end

class Phases
  def queue_size phase
    return unless valid_phase_name?(phase)
    phases[phase.to_sym].count
  end
end
