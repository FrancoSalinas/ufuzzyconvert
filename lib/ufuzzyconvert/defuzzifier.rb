module UFuzzyConvert

  require_relative 'exception'

  class Defuzzifier

    ##
    # Creates a defuzzifier using its FIS name.
    # @param [String] name
    #   Name of the defuzzifier used in FIS files.
    # @return [#to_cfs]
    #   A new defuzzifier of the required class.
    # @raise [FeatureError]
    #   When the name of the defuzzifier is not recognized.
    #
    def self.from_fis(name)
      case name
      when "centroid"
        return Centroid.new
      else
        raise FeatureError.new, "'#{name}' defuzzifier not recognized."
      end
    end

    ##
    # Converts the defuzzifier to CFS format.
    # @return [Array<Integer>]
    #   The defuzzifier converted.
    #
    def to_cfs
      return [self.class::CFS_TYPE]
    end
  end

  class Centroid < Defuzzifier
    CFS_TYPE = 0
  end
end
