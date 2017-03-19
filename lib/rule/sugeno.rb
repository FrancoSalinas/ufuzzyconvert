module UFuzzyConvert

  require_relative '../rule'

  class SugenoRule < Rule

    require_relative '../t_norm'

    ##
    # Converts a sugeno rule to CFS format.
    #
    # @return [Array<Integer>]
    #   Returns the rule converted to CFS format.
    #
    def to_cfs
      rule = Array.new

      if @connective.is_a? UFuzzyConvert::TNorm
        rule.push 0
      else
        rule.push 1
      end

      @antecedent.each do |antecedent|
        rule.push(*antecedent.to_cfs)
      end

      if rule.length & 1 != 0
        rule.push 0
      end

      inputs = @antecedent.map{|a| a.membership_function.variable}

      rule.concat @consequent.to_cfs(inputs)

      return rule
    end
  end
end
