module UFuzzyConvert
  module FixedPoint

    ##
    # Calculates the optimal range for a fixed point variable given its maximum
    # and minimum values.
    # @param [Numeric] min_value
    #   The minumum value the variable can take.
    # @param [Numeric] max_value
    #   The maximum value the variable can take.
    # @return [Numeric, Numeric]
    #   Returns a pair of values that should be used as {range_min} and
    #   {range_max}. If these values are used as a fixed point variable range,
    #   then the lower and higher values that can be held by that variable are
    #   {min_value} and {max_value} respectively.
    #
    def self.optimal_range(min_value, max_value)
      return [
        0x8000.to_f / 0xFFFF * (max_value - min_value) + min_value,
        0xC000.to_f / 0xFFFF * (max_value - min_value) + min_value
      ]
    end
  end
end

class Numeric

  require_relative 'exception'

  ##
  # Converts a number into its CFS fixed point representation.
  #
  # This function transforms a value within an interval into a number in the
  # [0x0000, 0x4000] interval and returns it as a pair of bytes in big endian
  # format.
  #
  # @example
  #   0.00.to_cfs(0, 1) #=> [0x00, 0x00]
  #   0.25.to_cfs(0, 1) #=> [0x10, 0x00]
  #   0.50.to_cfs(0, 1) #=> [0x20, 0x00]
  #   0.75.to_cfs(0, 1) #=> [0x30, 0x00]
  #   1.00.to_cfs(0, 1) #=> [0x40, 0x00]
  #
  # @param [Numeric] range_min
  #   Lower bound of the interval.
  # @param [Numeric] range_max
  #   Upper bound of the interval.
  # @param [Boolean] inclusive
  #   If true, the output belongs to [range_min, range_max]. If false, the
  #   output belongs to [range_min, range_max)
  # @return [Array<Integer>]
  #   Returns the number converted to CFS format.
  #
  def to_cfs(range_min = 0, range_max = 1, inclusive = true)
    delta = range_max - range_min

    # Normalize.
    if inclusive
      fp = (0x4000 * ((self * 1.0 - range_min) / delta)).round
    else
      fp = (0x3FFF * ((self * 1.0 - range_min) / delta)).floor
    end


    # Ensure the number can be represented by two bytes.
    if fp > 0x7FFF or fp < -0x8000
      raise UFuzzyConvert::InputError.new, "Fixed point value out of range."
    end

    # Return it as a pair of bytes.
    return [(fp >> 8) & 0xFF, fp & 0xFF]
  end
end
