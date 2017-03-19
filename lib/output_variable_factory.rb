module UFuzzyConvert

  class OutputVariableFactory

    require_relative 'output_variable/mamdani'
    require_relative 'output_variable/sugeno'

    CLASS_FROM_FIS_TYPE = {
      "mamdani" => UFuzzyConvert::MamdaniVariable,
      "sugeno" => UFuzzyConvert::SugenoVariable
    }

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

      return output_class.from_fis_data(output_data, system_data)
    end
  end
end
