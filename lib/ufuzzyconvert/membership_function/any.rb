module UFuzzyConvert

  module MembershipFunction

    require_relative 'base'

    ##
    # Class used to represent any membership function.
    #
    # This class is used by {Proposition} to represent a proposition that does
    # not affect a variable, i.e. 'INPUT IS ANY'
    #
    class Any < Base

      def ==(another)
        return self.variable == another.variable
      end

      def index
        return 0
      end
    end
  end
end
