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
        if not variable.is_a? UFuzzyConvert::Variable
          raise ArgumentError, "The variable associated to the membership "\
                               "must be an instance of UFuzzyConvert::Variable."
        end
        @variable = variable
      end

      #----------------------------[public methods]----------------------------#

      attr_reader :variable

      def index
        return @variable.membership_function_index self
      end

      #----------------------------[private class methods]---------------------#

      #----------------------------[private methods]---------------------------#

    end

  end

end
