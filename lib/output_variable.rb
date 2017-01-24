module UFuzzyConvert

  require_relative 'variable'

  class OutputVariable < Variable
    # @!attribute rules
    #   @return [Array<Rule>] Set of rules for this output.

    #----------------------------[constants]-----------------------------------#

    #----------------------------[public class methods]------------------------#

    ##
    # Creates an output variable from FIS data.
    #
    # @param [Hash] output_data
    #   The output section of a parsed FIS.
    #   An array with all the rules parsed.
    # @param [Hash] system_data
    #   The system section of a parsed FIS.
    # @option system_data [String] :Type
    #   The inference type: "mamdani" or "sugeno".
    # @return [MamdaniVariable, SugenoVariable]
    #   A new output variable object.
    # @raise [FeatureError]
    #  When a feature present in the FIS data is not supported.
    # @raise  [InputError]
    #  When the FIS data contains incomplete or erroneous information.
    #
    def self.from_fis_data(
      output_data,
      system_data
    )

      inference_type = system_data.fetch(:Type) {
        raise InputError.new, "Inference type not defined."
      }

      output_class = CLASS_FROM_FIS_TYPE.fetch(inference_type) {
        raise FeatureError.new,
        "Inference type #{inference_type} not supported."
      }

      begin
        return output_class.from_fis_data(output_data, system_data)
      rescue UFuzzyError
        raise $!, "Output #{output_data[:index]}: #{$!}", $!.backtrace
      end
    end

    #----------------------------[initialization]------------------------------#

    def initialize(range_min, range_max)
      super

      @rules = Array.new
    end

    #----------------------------[public methods]------------------------------#

    def rules
      return @rules.clone
    end

    def rules=(rules)
      @rules = rules.clone
    end

    #----------------------------[private class methods]-----------------------#

    #----------------------------[private methods]-----------------------------#

    private def rules_from_fis_data(
      rule_class, inputs, and_operator, or_operator, rules_data
    )
      rules = Array.new

      rules_data.each do |rule_data|
        rule = rule_class.from_fis_data(
          self, inputs, and_operator, or_operator, rule_data
        )
        if not rule.nil?
          rules.push rule
        end
      end

      return rules
    end
  end
end
