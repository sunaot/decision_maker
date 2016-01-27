require_relative 'decision_maker/version'

module DecisionMaker
  class Definition
    attr_accessor :api_name, :rule_table
    def name(api_name)
      self.api_name = api_name
    end

    def table(rule_table)
      self.rule_table = rule_table
    end
  end

  def self.define(&definition)
    d = Definition.new
    d.instance_eval(&definition)
    c = Class.new
    c.class_exec(d.api_name, d.rule_table) do |name, table|
      const_set 'TABLE', table
      define_method(name) do |key|
        rule_table[label(key)][name]
      end
      define_method(:rule_table) do
        self.class::TABLE
      end
      define_method(:label) do |key|
        result = rule_table.find do |label, rule|
          rule[:condition] === key
        end
        if result
          result.first
        else
          raise
        end
      end
    end
    c
  end
end


if __FILE__ == $0
  BonusPoint = DecisionMaker.define do
    name :point
    table(
      low:  { condition: 1..3, point: 10 },
      mid:  { condition: 4..7, point: 5 },
      high: { condition: 8..9, point: 3 },
    )
  end

  bp = BonusPoint.new

  puts bp.point(5)
end
