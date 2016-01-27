module DecisionMaker
  class DSL
    def definition
      porter
    end

    private
    Default = {
      rule_table: {},
      name: :call,
      condition_name: :condition,
      action_name: :action,
      error_handler: ->(key) { raise "cannot find rule for #{key}" },
    }
    Porter = Struct.new(*Default.keys)
    attr_accessor :porter

    def initialize
      self.porter = Porter.new(*Default.values)
    end

    def table(rule_table)
      porter.rule_table = rule_table
    end
    alias_method :rule, :table

    def table_name(table_name)
      self.class.module_exec(table_name) do |new_name|
        alias_method new_name, :table
      end
    end
    alias_method :rule_name, :table_name

    names = Default.keys - [:rule_table]
    names.each do |n|
      define_method(n) {|val| porter.send("#{n}=", val) }
    end
    alias_method :on_error,  :error_handler
  end
end
