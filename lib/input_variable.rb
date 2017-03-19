module UFuzzyConvert

  require_relative 'exception'
  require_relative 'membership_function'
  require_relative 'variable'

  class InputVariable < Variable

    #----------------------------[constants]-----------------------------------#

    #----------------------------[public class methods]------------------------#

    ##
    # Creates an {InputVariable} object from FIS data.
    #
    # @param [Hash] input_data
    #   The parsed input section of a FIS file.
    # @option input_data [Integer] :index
    #   Index of the input variable.
    # @option input_data [Hash] :parameters
    #   All the parameters of the input section, i.e. Range.
    # @option input_data [Array<Hash>] :membership
    #   An array with all the membership function data for this input variable.
    # @return [InputVariable]
    #   A new {InputVariable} object.
    # @raise [FeatureError]
    #  When a feature present in the FIS data is not supported.
    # @raise  [InputError]
    #  When the FIS data contains incomplete or erroneous information.
    #
    def self.from_fis_data(input_data)

      begin
        range_min, range_max = range_from_fis_data input_data

        return InputVariable.new range_min, range_max
      rescue UFuzzyError
        raise $!, "Input #{input_data[:index]}: #{$!}", $!.backtrace
      end
    end

    #----------------------------[initialization]------------------------------#

    #----------------------------[public methods]------------------------------#

    def membership_function_index(membership_function)
      index = @membership_functions.index membership_function

      if index.nil?
        raise ArgumentError, "The membership function does not belong to this "\
                             "input variable."
      else
        return index + 1
      end
    end

    ##
    # Converts an {InputVariable} into a CFS array.
    #
    # @param [Hash<Symbol>] options
    # @option options [Integer] :dsteps
    #   Base 2 logarithm of the number of defuzzification steps to be performed.
    # @option options [Integer] :tsize
    #   Base 2 logarithm of the number of entries in a tabulated membership
    #   function.
    # @return [Array<Integer>]
    #   Returns the input varaible converted to CFS format.
    # @raise  [InputError]
    #  When the FIS data contains incomplete or erroneous information.
    #
    def to_cfs(options)
      cfs_data = Array.new

      cfs_data.push(@membership_functions.length)
      cfs_data.push(0)

      @membership_functions.each do |membership_function|
        cfs_data.push(*membership_function.to_cfs(options))
      end

      return cfs_data
    end

    #----------------------------[private class methods]-----------------------#

    #----------------------------[private methods]-----------------------------#

  end

end
