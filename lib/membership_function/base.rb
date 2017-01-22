module UFuzzyConvert

  require_relative '../exception'
  require_relative '../fixed_point'
  require_relative '../variable'

  module MembershipFunction

    class Base

      #----------------------------[constants]---------------------------------#

      #----------------------------[public class methods]----------------------#

      #----------------------------[initialization]----------------------------#

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

      #----------------------------[public methods]----------------------------#

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

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
