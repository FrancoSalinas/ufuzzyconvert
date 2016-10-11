

class Numeric

  require_relative 'exception'

  def to_cfs(range_min, range_max)
    fp = 0x4000 * ((self * 1.0 - range_min) / (range_max - range_min))
    if fp > 0x7FFF or fp < -0x8000
      raise UFuzzyConvert::InputError.new, "Fixed point value out of range."
    end
    return [(fp.round >> 8) & 0xFF, fp.round & 0xFF]
  end

end
