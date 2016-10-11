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
  # @return [Array<Integer>]
  #   Returns the number converted to CFS format.
  #
  def to_cfs(range_min, range_max)
    delta = range_max - range_min

    # Normalize.
    fp = (0x4000 * ((self * 1.0 - range_min) / delta)).round

    # Ensure the number can be represented by two bytes.
    if fp > 0x7FFF or fp < -0x8000
      raise UFuzzyConvert::InputError.new, "Fixed point value out of range."
    end

    # Return it as a pair of bytes.
    return [(fp >> 8) & 0xFF, fp & 0xFF]
  end

end
