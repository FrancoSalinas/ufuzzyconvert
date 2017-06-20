module UFuzzyConvert

  module MembershipFunction

    require_relative 'membership_function/any'
    require_relative 'membership_function/base'
    require_relative 'membership_function/bell_shaped'
    require_relative 'membership_function/constant'
    require_relative 'membership_function/gaussian'
    require_relative 'membership_function/linear'
    require_relative 'membership_function/pi_shaped'
    require_relative 'membership_function/rectangular'
    require_relative 'membership_function/s_shaped'
    require_relative 'membership_function/sigmoid'
    require_relative 'membership_function/sigmoid_difference'
    require_relative 'membership_function/sigmoid_product'
    require_relative 'membership_function/trapezoidal'
    require_relative 'membership_function/triangular'
    require_relative 'membership_function/two_sided_gaussian'
    require_relative 'membership_function/z_shaped'

    CLASS_FROM_FIS_TYPE = {
      'dsigmf' => SigmoidDifference,
      'gaussmf' => Gaussian,
      'gauss2mf' => TwoSidedGaussian,
      'gbellmf' => BellShaped,
      'pimf' => PiShaped,
      'psigmf' => SigmoidProduct,
      'rectmf' => Rectangular,
      'smf' => SShaped,
      'sigmf' => Sigmoid,
      'trapmf' => Trapezoidal,
      'trimf' => Triangular,
      'zmf' => ZShaped
    }

    ##
    # Creates a membership function object from FIS data.
    #
    # @param [InputVariable] input_variable
    #   Input variable tied to this membership function.
    # @param [Hash] membership_data
    #   The membership function data parsed from a FIS file.
    # @option membership_data [Integer] :index
    #   Index of the membership function.
    # @option membership_data [String] :name
    #   The name of the membership function.
    # @option membership_data [String] :type
    #   The type of the membership function.
    # @option membership_data [Array<Numeric>] :parameters
    #   The parameters of the membership function. The meaning of each one
    #   depends on the type of membership function.
    # @return [MembershipFunction]
    #   A new {MembershipFunction} object.
    # @raise [FeatureError]
    #  When a feature present in the FIS data is not supported.
    # @raise  [InputError]
    #  When the FIS data contains incomplete or erroneous information.
    #
    def self.from_fis_data(input_variable, membership_data)

      if not membership_data.key? :index
        raise InputError.new, "Membership function index not defined."
      end

      begin
        if not membership_data.key? :type
          raise InputError.new, "Type not defined."
        end
        type = membership_data[:type]

        if not membership_data.key? :name
          raise InputError.new, "Name not defined."
        end
        name = membership_data[:name]

        if not membership_data.key? :parameters
          raise InputError.new, "Parameters not defined."
        end
        parameters = membership_data[:parameters]

        if type == 'linear'
          return Linear.new(input_variable, parameters, name)
        elsif type == 'constant'
          return Constant.new(input_variable, *parameters, name)
        else
          if not CLASS_FROM_FIS_TYPE.key? type
            raise FeatureError.new, "#{type} type not supported."
          end
          membership_class = CLASS_FROM_FIS_TYPE[type]

          parameter_number = membership_class::PARAMETER_NUMBER

          if parameters.length < parameter_number
            raise(
              InputError.new,
              "Must have at least #{parameter_number} parameters."
            )
          end

          return membership_class.new(
            input_variable,
            *parameters[0, parameter_number],
          name)
        end
      rescue UFuzzyError
        raise $!, "Membership #{membership_data[:index]}: #{$!}", $!.backtrace
      end
    end
  end
end
