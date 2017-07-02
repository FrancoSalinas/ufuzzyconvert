module UFuzzyConvert

  require_relative 'exception'

  module Connective

    FIS_TYPE_AND = 1
    FIS_TYPE_OR = 2

    ##
    # Creates a {TNorm} or {SNorm} object from FIS data.
    #
    # @param [TNorm] and_operator
    #   The AND operator used in the system.
    # @param [SNorm] or_operator
    #   Th OR operator used in the system
    # @param [Int] fis_type
    #   A number indicating the type of connective to create. 1 for AND, 0 for
    #   OR.
    # @return [TNorm, SNorm]
    #   A new {TNorm} or {SNorm} object.
    # data.
    # @raise  [FeatureError]
    #   When the type of connective is not recognized.
    #
    def self.from_fis_data(and_operator, or_operator, fis_type)

      if fis_type == FIS_TYPE_AND
        # May raise InputError.
        return and_operator
      elsif fis_type == FIS_TYPE_OR
        # May raise InputError.
        return or_operator
      else
        raise FeatureError.new, "Connective type #{fis_type} not supported."
      end
    end
  end
end
