module UFuzzyConvert

  require_relative '../rule'


  class MamdaniRule < Rule

    #----------------------------[constants]-------------------------------#

    #----------------------------[public class methods]--------------------#

    #----------------------------[initialization]--------------------------#

    #----------------------------[public methods]--------------------------#

    ##
    # Converts a mamdani rule to CFS format.
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
      rule.push @consequent.index

      return rule
    end

    #----------------------------[private class methods]-------------------#

    #----------------------------[private methods]-------------------------#

  end
end
