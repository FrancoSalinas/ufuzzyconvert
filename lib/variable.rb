module UFuzzyConvert

  class Variable

    require_relative 'exception'


    #----------------------------[constants]-----------------------------------#

    #----------------------------[public class methods]------------------------#

    def self.range_from_fis_data(variable_data)

      param_data = variable_data.fetch(:parameters) {
        raise InputError.new, "No parameters found. Range is required."
      }

      range = param_data.fetch(:Range) {
        raise InputError.new, "Range not defined."
      }

      if range.length != 2
        raise InputError.new, "Range matrix must have two elements."
      end

      return range[0], range[1]
    end

    #----------------------------[initialization]------------------------------#

    def initialize
      @membership_functions = Array.new
    end

    #----------------------------[public methods]------------------------------#

    def membership_functions
      return @membership_functions.clone
    end

    def membership_functions=(membership_functions)
      membership_functions.each do |membership_function|
        if membership_function.variable != self
          raise ArgumentError, "All the membership functions must belong to "\
                               "this variable."
        end
      end

      @membership_functions = membership_functions.clone
    end

    def load_membership_functions_from_fis_data(variable_data)
      membership_functions = Array.new

      if not variable_data.key? :membership
        raise InputError, "Membership functions not defined."
      end

      membership_data_list = variable_data[:membership]
      unless membership_data_list.nil?
        membership_data_list.each do |index, membership_data|
          membership_functions.push(
            MembershipFunction.from_fis_data(self, membership_data)
          )
        end
      end

      @membership_functions =  membership_functions
    end

    def membership_function_index(membership_function)
      index = @membership_functions.index membership_function

      if index.nil?
        raise ArgumentError, "The membership function does not belong to this "\
                             "variable."
      else
        return index + 1
      end
    end

    #----------------------------[private class methods]-----------------------#

    #----------------------------[private methods]-----------------------------#

  end
end
