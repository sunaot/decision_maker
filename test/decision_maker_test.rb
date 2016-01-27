require_relative 'test_helper'

TicketPrice = DecisionMaker.define do
  rule(
    child:   { condition:  0..9,   action: 600 },
    student: { condition: 10..16,  action: 1200 },
    adult:   { condition: 17..120, action: 2000 },
  )
end

TICKET_PRICE_TABLE = {
  child:   { condition:  0..9,   action: 600 },
  student: { condition: 10..16,  action: 1200 },
  adult:   { condition: 17..120, action: 2000 },
}

class DecisionMakerTest < Minitest::Test
  def test_define
    ticket_price = TicketPrice.new
    assert_equal 600, ticket_price.for(:child)
  end

  def test_change_condition_name
    ticket_price = DecisionMaker.generate do
      condition_name :age
      table(
        child:   { age:  0..9,   action: 600 },
        student: { age: 10..16,  action: 1200 },
        adult:   { age: 17..120, action: 2000 },
      )
    end
    assert_equal 600, ticket_price.for(:child)
  end

  def test_change_action_name
    ticket_price = DecisionMaker.generate do
      condition_name :age
      action_name :price
      table(
        child:   { age:  0..9,   price: 600 },
        student: { age: 10..16,  price: 1200 },
        adult:   { age: 17..120, price: 2000 },
      )
    end
    assert_equal 600, ticket_price.for(:child)
  end

  def test_change_table_name
    ticket_price = DecisionMaker.generate do
      table_name :price_table
      price_table(
        child:   { condition:  0..9,   action: 600 },
        student: { condition: 10..16,  action: 1200 },
        adult:   { condition: 17..120, action: 2000 },
      )
    end
    assert_equal 1200, ticket_price.call(10)
  end

  def test_change_rule_name
    ticket_price = DecisionMaker.generate do
      rule_name :price
      price(
        child:   { condition:  0..9,   action: 600 },
        student: { condition: 10..16,  action: 1200 },
        adult:   { condition: 17..120, action: 2000 },
      )
    end
    assert_equal 1200, ticket_price.call(16)
  end

  def test_change_evaluation_method_name
    ticket_price = DecisionMaker.generate do
      name :evaluate
      rule(
        child:   { condition:  0..9,   action: 600 },
        student: { condition: 10..16,  action: 1200 },
        adult:   { condition: 17..120, action: 2000 },
      )
    end
    assert_equal 1200, ticket_price.evaluate(10)
  end

  def test_use_proc_on_condition
    ticket_price = DecisionMaker.generate do
      rule(
        child:   { condition:  0..9,   action: 600 },
        student: { condition: 10..16,  action: 1200 },
        adult:   { condition: ->(age) { age > 16 }, action: 2000 },
      )
    end
    assert_equal 2000, ticket_price.call(17)
  end

  def test_conditions_class_instance_match
    dm = DecisionMaker.generate do
      rule(
        fixnum: { condition: Fixnum, action: 'fixnum' },
        hash:   { condition: Hash,   action: 'hash' },
        enum:   { condition: Enumerator, action: 'enumerator' },
      )
    end
    assert_equal 'fixnum', dm.call(1)
  end

  def test_conditions_regexp
    dm = DecisionMaker.generate do
      rule(
        tel: { condition: /^(080|090|070)/, action: 'tel-number' }
      )
    end
    assert_equal 'tel-number', dm.call('080-0000-0000')
  end

  def test_evaluation_method_name_is_not_alias
    dm = DecisionMaker.generate do
      name :another
      rule(a: { condition: 1, action: 'abc' })
    end
    assert_raises(NoMethodError) do
      dm.call(1)
    end
  end

  def test_raise_error_on_missing_condition
    dm = DecisionMaker.generate do
      rule(a: { condition: 1, action: 'abc' })
    end
    assert_raises(RuntimeError) do
      dm.call(:unknown_key)
    end
  end
end
