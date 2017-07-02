module UFuzzyConvert

  require_relative '../exception'

  module MembershipFunction

    require_relative 'tabulated'

    class PiShaped < Tabulated

      PARAMETER_NUMBER = 4

      ##
      # Creates a pi-shaped membership function.
      #
      # `
      # f(x) = {
      # (0 , if x le a text(,)),
      # (2 ((x-a)/(b-a))^2, if a le x le (a+b)/2 text(,)),
      # (1 - 2 ((x-b)/(b-a))^2, if (a + b)/2 le x le b text(,)),
      # (1, if b le x le c text(,)),
      # (1 - 2 ((x-c)/(d-c))^2, if c le x le (c + d)/2 text(,)),
      # (2 ((x-d)/(d-c))^2, if (c+d)/2 le x le d text(,)),
      # (0, if x ge d)
      # :}
      # `
      #
      # @param [Variable] variable
      #   Variable associated to this membership function.
      # @param [Numeric] a
      #   x-coordinate where the slope starts growing.
      # @param [Numeric] b
      #   x-coordinate where the slope stops growing.
      # @param [Numeric] c
      #   x-coordinate where the slope starts falling.
      # @param [Numeric] d
      #   x-coordinate where the slope stops falling.
      # @param [String] name
      #   The name of the membership function.
      # @raise [InputError]
      #   When a, b, c or b have invalid values.
      #
      def initialize(variable, a, b, c, d, name = "")
        super(variable)

        if (
          not a.is_a? Numeric or
          not b.is_a? Numeric or
          not c.is_a? Numeric or
          not d.is_a? Numeric
        )
          raise InputError.new, "Parameters must be numeric."
        end

        if a >= b or b > c or c >= d
          raise InputError.new, "Parameters are not ordered."
        end

        @name = name
        @a = a.to_f
        @b = b.to_f
        @c = c.to_f
        @d = d.to_f
      end

      def evaluate(x)
        if x < @a
          return 0
        end

        if x < (@a + @b) / 2
          return 2 * ((x - @a) / (@b - @a)) ** 2
        end

        if x < @b
          return 1 - 2 * ((x - @b) / (@b - @a)) ** 2
        end

        if x < @c
          return 1
        end

        if x < (@c + @d) / 2
          return 1 - 2 * ((x - @c) / (@d - @c)) ** 2
        end

        if x < @d
          return 2 * ((x - @d) / (@d - @c)) ** 2
        end

        return 0
      end
    end
  end
end
