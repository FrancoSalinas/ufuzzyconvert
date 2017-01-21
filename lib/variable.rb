module UFuzzyConvert

  module Variable

    require_relative 'exception'

    def range_from_fis_data(variable_data)

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

    def membership_functions_from_fis_data(variable_data)
      membership_functions = Array.new

      membership_data_list = variable_data[:membership]
      unless membership_data_list.nil?
        membership_data_list.each do |index, membership_data|
          membership_functions.push(
            MembershipFunction.from_fis_data(self, membership_data)
          )
        end
      end

      return membership_functions
    end
  end

end
