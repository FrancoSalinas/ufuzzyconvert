module UFuzzyConvert

  module OutputVariable

    require_relative 'output_variable/mamdani'
    require_relative 'output_variable/sugeno'

    CLASS_FROM_FIS_TYPE = {
      "mamdani" => Mamdani,
      "sugeno" => Sugeno
    }

    ##
    # Creates an output variable from FIS data.
    #
    # @param [Hash] fis_data
    #   A parsed FIS.
    # @option fis_data [Hash] :system
    #   The System section parsed.
    # @option fis_data [Hash<Int, Hash>] :outputs
    #   A hash with all the output variables parsed, where the key is the
    #   output variable index.
    # @option fis_data [Array<Hash>] :rules
    #   An array with all the rules parsed.
    # @param [Integer] index
    #   The index of the output variable to be parsed.
    # @return [OutputVariable::Mamdani, OutputVariable::Sugeno]
    #   A new output variable object.
    # @raise [FeatureError]
    #  When a feature present in the FIS data is not supported.
    # @raise  [InputError]
    #  When the FIS data contains incomplete or erroneous information.
    #
    def self.from_fis_data(fis_data, index)

      system_section = fis_data.fetch(:system) {
        raise InputError.new, "System section not defined."
      }

      inference_type = system_section.fetch(:Type) {
        raise InputError.new, "Inference type not defined."
      }

      output_class = CLASS_FROM_FIS_TYPE.fetch(inference_type) {
        raise FeatureError.new,
        "Inference type #{inference_type} not supported."
      }

      begin
        return output_class.from_fis_data(fis_data, index)
      rescue UFuzzyError
        raise $!, "Output #{index}: #{$!}", $!.backtrace
      end
    end

  end

end
