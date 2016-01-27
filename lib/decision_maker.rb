require_relative 'decision_maker/version'
require_relative 'decision_maker/dsl'
require_relative 'decision_maker/class_definition'

module DecisionMaker
  #  @example DecisionMaker.generate
  #    ticket_price = DecisionMaker.generate do
  #      rule(
  #        child:   { condition:  0..9,   action: 600 },
  #        student: { condition: 10..16,  action: 1200 },
  #        adult:   { condition: ->(age) { age > 16 }, action: 2000 },
  #      )
  #    end
  #
  #    ticket_price.call(20) #=> 2000
  #
  # @example Customizing names are available. It makes your code more illustrative
  #    ticket_price = DecisionMaker.generate do
  #      name           :calculate
  #      condition_name :age
  #      action_name    :price
  #
  #      rule(
  #        child:   { age:  0..9,   price: 600 },
  #        student: { age: 10..16,  price: 1200 },
  #        adult:   { age: ->(age) { age > 16 }, price: 2000 },
  #      )
  #    end
  #
  #    ticket_price.calculate(20) #=> 2000
  def self.generate(&definition)
    decision_table = define(&definition)
    decision_table.new
  end

  def self.define(&definition)
    dsl = DSL.new
    dsl.instance_eval(&definition)
    d = dsl.definition
    ClassDefinition.customize(d.rule_table, d.name, d.condition_name, d.action_name, d.error_handler)
  end
end
