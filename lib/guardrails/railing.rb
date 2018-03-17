module Guardrails
  # noinspection RubyClassVariableUsageInspection
  class Railing
    @@situations = []
    def initialize(specifications)
      @specifications = specifications
    end

    def self.add_situation(situation)
      @@situations.push(situation)
    end

    def check_specs
      hold_references_to_instances

      yield

      unfulfilled_specifications = @specifications.reject do |specification|
        @@situations.any? do |situation|
          specification.match(situation)
        end
      end
      outcome = Struct.new(:unfulfilled).new(unfulfilled_specifications)
      OutcomeFormatter.new(outcome).tap do
        @@situations = []
      end
    end

    def hold_references_to_instances
      @specifications.map(&:klass).uniq.each do |klass|
        klass.send(:prepend, SituationTracker)
      end
    end

    module SituationTracker
      def initialize(*_)
        Railing.add_situation(self)
        super
      end
    end
  end

  class OutcomeFormatter
    def initialize(outcome)
      @outcome = outcome
    end

    def to_s
      if all_fulfilled?
        'All specifications were fulfuilled'
      else
        "Not all specifications were fulfilled: \n\t#{@outcome.unfulfilled.join('\n\t')}"
      end
    end

    def all_fulfilled?
      @outcome.unfulfilled.empty?
    end
  end
end
