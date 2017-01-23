module UFuzzyConvert

  class OutputVariable < Variable
    # @!attribute rules
    #   @return [Array<Rule>] Set of rules for this output.

    require_relative 'output_variable/mamdani'
    require_relative 'output_variable/sugeno'

    #----------------------------[constants]-----------------------------------#

    CLASS_FROM_FIS_TYPE = {
      "mamdani" => UFuzzyConvert::MamdaniVariable,
      "sugeno" => UFuzzyConvert::SugenoVariable
    }

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
  end

  #----------------------------[initialization]--------------------------------#

  def initialize(range_min, range_max)
    super(range_min, range_max)

    @rules = Array.new
  end

  #----------------------------[public methods]--------------------------------#

  def rules
    return @rules.clone
  end

  def rules=(rules)
    @rules = rules.clone
  end

  def load_rules_from_fis_data(
    inputs, and_operator, or_operator, rules_data
  )
    rules = Array.new

    rules_data.each do |rule_data|
      rule = RULE_CLASS.from_fis_data(
        output, inputs, and_operator, or_operator, rule_data
      )
      if not rule.nil?
        rules.push rule
      end
    end

    @rules = rules
  end

  #----------------------------[private class methods]-------------------------#

  #----------------------------[private methods]-------------------------------#

end
