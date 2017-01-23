module UFuzzyConvert

  require_relative 'exception'

  class Rule

    #----------------------------[constants]-------------------------------#

    #----------------------------[public class methods]--------------------#

    ##
    # Creates a rule from FIS data.
    #
    # @param [OutputVariable] output
    #   The output variable which this rule affects.
    # @param [Array<InputVariable>] inputs
    #   An array with all the input variables of the system.
    # @param [TNorm] and_operator
    #   The AND operator used in the system.
    # @param [SNorm] or_operator
    #   The OR operator used in the system.
    # @param [Hash] rule_data
    #   The rule data extracted from the FIS file.
    # @option rule_data [Array<Integer>] :antecedent
    #   The rule antecedent. Its length must be equal to the number of
    #   input variables of the system.
    # @option rule_data [Array<Integer>] :consequent
    #   The rule consequent. Its length must be equal to the number of
    #   output variables of the system.
    # @option rule_data [Integer] :connective
    #  Type of logic connective to use in the rule.
    # @option rule_data [Numeric] :weight
    #  The rule weight.
    # @return [Rule, nil]
    #   Returns a new rule created from the FIS data or nil, if the rule
    #   data provided does not affect the output variable.
    # @raise [FeatureError]
    #  When an consequent uses a negated membership function.
    # @raise  [InputError]
    #  When the FIS data contains incomplete or erroneous information.
    #
    def self.from_fis_data(
      output, inputs, and_operator, or_operator, rule_data
    )

      # Check if the rule parameters are present.

      antecedent_data = rule_data.fetch(:antecedent) {
        raise InputError.new, "Rule antecedent not defined."
      }

      consequent_data = rule_data.fetch(:consequent) {
        raise InputError.new, "Rule consequent not defined."
      }

      weight = rule_data.fetch(:weight) {
        raise InputError.new, "Rule weight not defined."
      }

      connective_data = rule_data.fetch(:connective) {
        raise InputError.new, "Rule connective not defined."
      }

      # Create the connective.
      # May raise FeatureError.
      connective = UFuzzyConvert::Connective.from_fis_data(
        and_operator, or_operator, connective_data
      )

      # Create the antecedent.
      # May raise InputError.
      antecedent = antecedent_from_fis_data(inputs, antecedent_data)

      # Create the consequent.
      # May raise FeatureError, InputError.
      consequent = consequent_from_fis_data(output, consequent_data)

      if consequent.nil?
        return nil
      else
        return Rule.new(
          antecedent,
          consequent,
          connective,
          weight
        )
      end
    end

    #----------------------------[initialization]--------------------------#

    ##
    # Creates a rule object.
    #
    # @param [Array<Proposition>] antecedent
    #   An array of propositions.
    # @param [MembershipFunction::Base] consequent
    #   The index of the output membership function used in this rule.
    # @param [UFuzzyConvert::SNorm, UFuzzyConvert::TNorm] connective
    #   Logic connective.
    # @param [Numeric] weight
    #   A number indicating the weight of this rule.
    #
    def initialize(
      antecedent,
      consequent,
      connective,
      weight
    )
      @antecedent = antecedent
      @consequent = consequent
      @connective = connective
      @weight = weight
    end

    #----------------------------[public methods]--------------------------#

    def antecedent
      return @antecedent.clone
    end

    attr_reader :consequent
    attr_reader :connective
    attr_reader :weight

    #----------------------------[private class methods]-------------------#

    private_class_method def self.antecedent_from_fis_data(
      inputs, antecedent_data
    )
      if antecedent_data.size != inputs.size
        raise InputError.new, "Rule antecedent should have #{inputs.size} "\
                              "propositions."
      end

      antecedent = Array.new

      antecedent_data.zip(
        inputs
      ).each do |membership_function_index, input|

        # May raise InputError.
        proposition = Proposition.from_fis_data(
          input, membership_function_index
        )

        if not proposition.nil?
          antecedent.push proposition
        end
      end

      return antecedent
    end

    private_class_method def self.consequent_from_fis_data(
      output, consequent_data
    )
      if output.index > consequent_data.size
        raise InputError.new, "Rule consequent should have at least "\
                              "#{output.index} propositions."
      end
      membership_function_index = consequent_data[output.index - 1]

      if membership_function_index == 0
        return nil
      elsif membership_function_index < 0
        raise FeatureError.new, "Negated consequents are not supported."
      elsif membership_function_index > output.membership_functions.size
        raise InputError.new, "Membership function index "\
                              "#{membership_function_index} is not valid "\
                              "for output #{output.index}."
      else
        return output.membership_functions[membership_function_index - 1]
      end
    end

    #----------------------------[private methods]-------------------------#

  end
end
