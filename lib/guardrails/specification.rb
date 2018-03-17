module Guardrails
  class Specification
    def initialize(klass, name, check)
      @klass = klass
      @name = name
      @check = check
    end

    attr_reader :klass

    def match(situation)
      return false unless situation.is_a?(@klass)
      @check.call(situation)
    end

    def to_s
      @name.to_s
    end
  end
end