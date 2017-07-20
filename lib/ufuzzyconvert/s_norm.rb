module UFuzzyConvert

  require_relative 'exception'

  class SNorm

    ##
    # Creates ast-norm using its FIS name.
    # @param [String] name
    #   Name of the S-Norm used in FIS files.
    # @return [SNorm]
    #   A new SNorm of the required class.
    # @raise [FeatureError]
    #   When the name of the s-norm is not recognized.
    #
    def self.from_fis(name)
      case name
      when "max"
        return SNormMaximum.new
      when "sum", "algebraic_sum", "probor"
        return SNormSum.new
      when "bounded_sum"
        return SNormBoundedSum.new
      when "drastic_sum"
        return SNormDrasticSum.new
      when "einstein_sum"
        return SNormEinsteinSum.new
      when "hamacher_sum"
        return SNormHamacherSum.new
      else
        raise FeatureError.new, "'#{name}' s-norm not recognized."
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

  class SNormMaximum < SNorm
    CFS_TYPE = 0
  end

  class SNormSum < SNorm
    CFS_TYPE = 1
  end

  class SNormBoundedSum < SNorm
    CFS_TYPE = 2
  end

  class SNormDrasticSum < SNorm
    CFS_TYPE = 3
  end

  class SNormEinsteinSum < SNorm
    CFS_TYPE = 4
  end

  class SNormHamacherSum < SNorm
    CFS_TYPE = 5
  end
end
