module UFuzzyConvert

  require_relative 'exception'

  class TNorm

    ##
    # Creates a t-norm using its FIS name.
    # @param [String] name
    #   Name of the T-Norm used in FIS files.
    # @return [TNorm]
    #   A new TNorm of the required class.
    # @raise [FeatureError]
    #   When the name of the t-norm is not recognized.
    #
    def self.from_fis(name)
      case name
      when "min"
        return TNormMinimum.new
      when "prod", "algebraic_product"
        return TNormProduct.new
      when "bounded_difference"
        return TNormBoundedDifference.new
      when "drastic_product"
        return TNormDrasticProduct.new
      when "einstein_product"
        return TNormEinsteinProduct.new
      when "hamacher_product"
        return TNormHamacherProduct.new
      else
        raise FeatureError.new, "#{name} t-norm not recognized."
      end
    end

    ##
    # Converts the t-norm to CFS format.
    # @return [Array<Integer>]
    #   The t-norm converted.
    #
    def to_cfs
      return [self.class::CFS_TYPE]
    end

  end

  class TNormMinimum < TNorm
    CFS_TYPE = 0
  end

  class TNormProduct < TNorm
    CFS_TYPE = 1
  end

  class TNormBoundedDifference < TNorm
    CFS_TYPE = 2
  end

  class TNormDrasticProduct < TNorm
    CFS_TYPE = 3
  end

  class TNormEinsteinProduct < TNorm
    CFS_TYPE = 4
  end

  class TNormHamacherProduct < TNorm
    CFS_TYPE = 5
  end
end
