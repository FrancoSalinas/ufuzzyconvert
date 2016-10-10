module UFuzzyConvert

  ##
  # Exception class for uFuzzyConvert errors. All the exceptions raised by this
  # module are subclasses of this class.
  #
  class UFuzzyError < Exception
  end

  ##
  # Exception raised when the conversion requires a feature which is not
  # supported yet.
  #
  class FeatureError < UFuzzyError
  end

  ##
  # Exception raised when there is an error in the input data, i.e., a FIS file
  # with invalid format.
  #
  class InputError < UFuzzyError
  end

end
