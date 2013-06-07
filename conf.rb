module PhaseControl
  extend self

  def definitions
    @definitions ||= Hash.new {|h| h = []}
  end

  def add(phase, ticket, who)
    definitions[phase] << Role.new(phase, ticket, who)
  end

  def [](phase)
    definitions[phase]
  end

  class Role
    attr_reader :ticket

    def initialize(name, ticket, who)
      @name   = name
      @ticket = ticket
      @who    = who
    end

    def to_s
      @name
    end
  end
end
