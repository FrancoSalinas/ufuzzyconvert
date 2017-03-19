module UFuzzyConvert

  require_relative '../exception'
  require_relative '../fixed_point'
  require_relative '../variable'

  module MembershipFunction

    class Base
      ##
      # Creates a base membership function.
      #
      # All the membership function instances are subclasses of this class.
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      #
      def initialize(variable)
        @variable = variable
      end

      attr_reader :variable

      ##
      # Returns the index of this membership function.
      #
      # @return [Integer]
      #   Returns a number from 1 to n, indicating the index of this membership
      #   function for the variable it is related to.
      #
      def index
        return @variable.membership_function_index self
      end
    end
  end
end
