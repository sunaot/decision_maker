module DecisionMaker
  class ClassDefinition
    def self.customize(rule_table, name, condition_name, action_name, error_handler)
    args = [rule_table, name, condition_name, action_name, error_handler]
    c = Class.new
    c.class_exec(*args) do |table, name, condition_name, action_name, error_handler|
      const_set 'TABLE', table

      define_method(:rule_table) { self.class::TABLE }

      define_method(name) do |key|
        rule_table[label(key)].fetch(action_name)
      end

      define_method(:label) do |key|
        found = rule_table.find do |label, rule|
          rule[condition_name] === key
        end
        if found
          rule_label, rule_content = found
          rule_label
        else
          error_handler.call(key)
        end
      end

      define_method(:for) do |label|
        rule_table[label].fetch(action_name)
      end
    end
    c
    end
  end
end
