require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/fis_parser'
include Mocha::API


class FisParserTest < Test::Unit::TestCase
  def test_parse_simple
    fis_str = <<EOS
[System]
Type = 'mamdani'
AndMethod = 'min'
OrMethod = 'max'
ImpMethod = 'min'
AggMethod = 'max'
DefuzzMethod = 'centroid'

[Input1]
Range = [-20 20]
MF1='cold':'trimf',[-20 0 20]

[Output1]
Range = [-0.3 0.3]
MF1='steady':'trimf',[-0.3 0 0.3]

[Rules]
1, 1 (1) : 1
-1, -1 (0.5) : 2

EOS

    fis_data = Parser.parse(fis_str)

    assert_equal "mamdani", fis_data[:system][:Type]
    assert_equal "min", fis_data[:system][:AndMethod]
    assert_equal "max", fis_data[:system][:OrMethod]
    assert_equal "min", fis_data[:system][:ImpMethod]
    assert_equal "max", fis_data[:system][:AggMethod]
    assert_equal "centroid", fis_data[:system][:DefuzzMethod]

    assert_equal 1, fis_data[:inputs].length
    assert_equal 1, fis_data[:inputs][1][:index]
    assert_equal 1, fis_data[:inputs][1][:parameters].length
    assert_equal [-20, 20], fis_data[:inputs][1][:parameters][:Range]

    assert_equal 1, fis_data[:inputs][1][:membership].length
    assert_equal 1, fis_data[:inputs][1][:membership][1][:index]
    assert_equal "trimf", fis_data[:inputs][1][:membership][1][:type]
    assert_equal [-20, 0, 20], fis_data[:inputs][1][:membership][1][:parameters]

    assert_equal 1, fis_data[:outputs].length
    assert_equal 1, fis_data[:outputs][1][:index]
    assert_equal 1, fis_data[:outputs][1][:parameters].length
    assert_equal [-0.3, 0.3], fis_data[:outputs][1][:parameters][:Range]

    assert_equal 1, fis_data[:outputs][1][:membership].length
    assert_equal 1, fis_data[:outputs][1][:membership][1][:index]
    assert_equal "trimf", fis_data[:outputs][1][:membership][1][:type]
    assert_equal [-0.3, 0, 0.3], fis_data[:outputs][1][:membership][1][:parameters]

    assert_equal 2, fis_data[:rules].length
    assert_equal [1], fis_data[:rules][0][:antecedent]
    assert_equal [1], fis_data[:rules][0][:consequent]
    assert_equal 1, fis_data[:rules][0][:connective]
    assert_equal 1, fis_data[:rules][0][:weight]
    assert_equal [-1], fis_data[:rules][1][:antecedent]
    assert_equal [-1], fis_data[:rules][1][:consequent]
    assert_equal 2, fis_data[:rules][1][:connective]
    assert_equal 0.5, fis_data[:rules][1][:weight]
  end

  def test_parse_complete
    fis_str = <<EOS
[System]
Type = 'mamdani'
AndMethod = 'prod'
OrMethod = 'sum'
ImpMethod = 'prod'
AggMethod = 'sum'
DefuzzMethod = 'centroid'
IgnoredParam = 'some value'

[Input1]
Range = [-20 20]
MF1='cold':'trimf',[-20 -20 0]
MF2='normal':'trimf',[-20 0 20]
MF3='hot':'trimf',[0 20 20]

[Input2]
Range = [0 40]
MF1='cold':'trimf',[0 0 20]
MF2='normal':'trimf',[0 40 40]

[Output1]
Range = [-0.3 0.3]
MF1='slow':'trimf',[-0.3 -0.3 0.3]
MF2='fast':'trimf',[-0.3 0 0.3]

[Output2]
Range = [10 20]
MF1='steady':'trapmf',[10 14 16 20]

[Rules]
1 1, 1 1 (1) : 1
1 2, 2 1 (1) : 1
2 1, 2 -1 (1) : 1
2 2, 1 -1 (1) : 1
3 1, 2 0 (1) : 1
3 2, 1 0 (1) : 1

EOS

    fis_data = Parser.parse(fis_str)

    # Input 1.
    assert_equal 2, fis_data[:inputs].length
    assert_equal 1, fis_data[:inputs][1][:index]
    assert_equal 1, fis_data[:inputs][1][:parameters].length
    assert_equal [-20, 20], fis_data[:inputs][1][:parameters][:Range]

    # Membership functions for input 1.
    assert_equal 3, fis_data[:inputs][1][:membership].length
    assert_equal 1, fis_data[:inputs][1][:membership][1][:index]
    assert_equal "trimf", fis_data[:inputs][1][:membership][1][:type]
    assert_equal [-20, -20, 0], fis_data[:inputs][1][:membership][1][:parameters]
    assert_equal 2, fis_data[:inputs][1][:membership][2][:index]
    assert_equal "trimf", fis_data[:inputs][1][:membership][2][:type]
    assert_equal [-20, 0, 20], fis_data[:inputs][1][:membership][2][:parameters]
    assert_equal 3, fis_data[:inputs][1][:membership][3][:index]
    assert_equal "trimf", fis_data[:inputs][1][:membership][3][:type]
    assert_equal [0, 20, 20], fis_data[:inputs][1][:membership][3][:parameters]

    # Input 2.
    assert_equal 2, fis_data[:inputs][2][:index]
    assert_equal 1, fis_data[:inputs][2][:parameters].length
    assert_equal [0, 40], fis_data[:inputs][2][:parameters][:Range]

    # Membership functions for input 2.
    assert_equal 2, fis_data[:inputs][2][:membership].length
    assert_equal 1, fis_data[:inputs][2][:membership][1][:index]
    assert_equal "trimf", fis_data[:inputs][2][:membership][1][:type]
    assert_equal [0, 0, 20], fis_data[:inputs][2][:membership][1][:parameters]
    assert_equal 2, fis_data[:inputs][2][:membership][2][:index]
    assert_equal "trimf", fis_data[:inputs][2][:membership][2][:type]
    assert_equal [0, 40, 40], fis_data[:inputs][2][:membership][2][:parameters]


    assert_equal 2, fis_data[:outputs].length

    # Output 1.
    assert_equal 1, fis_data[:outputs][1][:index]
    assert_equal 1, fis_data[:outputs][1][:parameters].length
    assert_equal [-0.3, 0.3], fis_data[:outputs][1][:parameters][:Range]

    assert_equal 2, fis_data[:outputs][1][:membership].length
    assert_equal 1, fis_data[:outputs][1][:membership][1][:index]
    assert_equal "trimf", fis_data[:outputs][1][:membership][1][:type]
    assert_equal [-0.3, -0.3, 0.3], fis_data[:outputs][1][:membership][1][:parameters]
    assert_equal 2, fis_data[:outputs][1][:membership][2][:index]
    assert_equal "trimf", fis_data[:outputs][1][:membership][2][:type]
    assert_equal [-0.3, 0, 0.3], fis_data[:outputs][1][:membership][2][:parameters]

    # Output 2.
    assert_equal 2, fis_data[:outputs][2][:index]
    assert_equal 1, fis_data[:outputs][2][:parameters].length
    assert_equal [10, 20], fis_data[:outputs][2][:parameters][:Range]

    assert_equal 1, fis_data[:outputs][2][:membership].length
    assert_equal 1, fis_data[:outputs][2][:membership][1][:index]
    assert_equal "trapmf", fis_data[:outputs][2][:membership][1][:type]
    assert_equal [10, 14, 16, 20], fis_data[:outputs][2][:membership][1][:parameters]
  end

  def test_parse_without_blank_lines
    fis_str = <<EOS
[System]
Type = 'mamdani'
AndMethod = 'min'
OrMethod = 'max'
ImpMethod = 'min'
AggMethod = 'max'
DefuzzMethod = 'centroid'
[Input1]
Range = [-20 20]
MF1='cold':'trimf',[-20 0 20]
[Output1]
Range = [-0.3 0.3]
MF1='steady':'trimf',[-0.3 0 0.3]
[Rules]
1, 1 (1) : 1
-1, -1 (0.5) : 2
EOS
    # Remove EOL.
    fis_str.chomp!

    fis_data = Parser.parse(fis_str)

    assert_equal 1, fis_data[:inputs].length
    assert_equal 1, fis_data[:outputs].length
    assert_equal 2, fis_data[:rules].length
  end

  def test_parse_with_first_lines_empty
    fis_str = <<EOS


[System]
Type = 'mamdani'
AndMethod = 'min'
OrMethod = 'max'
ImpMethod = 'min'
AggMethod = 'max'
DefuzzMethod = 'centroid'

[Input1]
Range = [-20 20]
MF1='cold':'trimf',[-20 0 20]

[Output1]
Range = [-0.3 0.3]
MF1='steady':'trimf',[-0.3 0 0.3]

[Rules]
1, 1 (1) : 1
-1, -1 (0.5) : 2
EOS
    fis_data = Parser.parse(fis_str)

    assert_equal 1, fis_data[:inputs].length
    assert_equal 1, fis_data[:outputs].length
    assert_equal 2, fis_data[:rules].length
  end

  def test_parse_with_spaces
    fis_str = <<EOS
[ System]
Type='mamdani'
  AndMethod = 'min'
OrMethod ='max'#{'  '}

#{"\t"}ImpMethod = 'min'
AggMethod = 'max'#{"\t"}
DefuzzMethod   =   'centroid'

[Input1 ]
Range = [  -20 20]
MF1='cold':'trimf',[-20    0 20]

#{"\t"}[Output1]
Range = [-0.3 0.3   ]
#{"\t"}

#{"\t"}
MF1 = 'steady' : 'trimf' , [-0.3 0 0.3]
#{"     "}
[Rules]#{"\t"}

1, 1 (1):1

#{"\t"}

   -1   , -1 (  0.5  ) : 2
EOS
    fis_data = Parser.parse(fis_str)

    assert_equal 1, fis_data[:inputs].length
    assert_equal 1, fis_data[:outputs].length
    assert_equal 2, fis_data[:rules].length
  end
end
