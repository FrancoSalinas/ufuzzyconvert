module UFuzzyConvert

  require_relative 'exception'
  require_relative 'membership_function'

  class Proposition

    #----------------------------[constants]-----------------------------------#

    #----------------------------[public class methods]------------------------#

    ##
    # Creates a proposition from FIS data
    #
    # @param [InputVariable] input
    #   The variable this proposition affects to.
    # @param [Integer] membership_function_index
    #   The index of the membership function in the FIS data.
    # @return [OutputVariable::Proposition]
    #   Returns a new proposition or nil if the membership function index is
    #   0.
    # @raise [InputError]
    #   If the membership function index is not valid.
    #
    def self.from_fis_data(input, membership_function_index)
      if membership_function_index == 0
        membership_function = MembershipFunction::Any.new(input)
        negated = false
      else
        negated = membership_function_index < 0
        membership_function_index = membership_function_index.abs

        membership_function = input.membership_functions.fetch(
          membership_function_index - 1
        ) {
          raise InputError.new, "Membership function index "\
                                "#{membership_function_index} is not valid "\
                                "for input #{input.index}."
        }
      end

      return Proposition.new(membership_function, negated)
    end

    #----------------------------[initialization]------------------------------#

    ##
    # Creates a mamdani output variable object.
    #
    # @param [MembershipFunction] membership_function
    #   The membership function affected in this proposition.
    # @param [Boolean] negated
    #   An optional c-norm.
    #
    def initialize(
      membership_function,
      negated=false
    )
      @membership_function = membership_function
      @negated = negated
    end

    #----------------------------[public methods]------------------------------#

    attr_reader :membership_function
    attr_reader :negated

    def ==(another)
      return @membership_function == another.membership_function &&
             @negated == another.negated
    end

    ##
    # Converts a proposition to CFS format
    #
    # @return [Array<Integer>]
    #   Returns the proposition converted to CFS format.
    #
    def to_cfs
      if @negated
        return [-@membership_function.index]
      else
        return [@membership_function.index]
      end
    end

    #----------------------------[private class methods]-----------------------#

    #----------------------------[private methods]-----------------------------#

  end
end
