module Fis

  class Body < Treetop::Runtime::SyntaxNode
    def to_hash
      return {
        :system => self.elements[0].to_hash,
        :inputs => self.elements[1].to_hash,
        :outputs => self.elements[2].to_hash,
        :rules => self.elements[3].to_hash
      }
    end
  end

  class System < Treetop::Runtime::SyntaxNode
    def to_hash
      return self.elements[0].to_hash
    end
  end

  class ParameterList < Treetop::Runtime::SyntaxNode
    def to_hash
      return self.elements.map {|x| x.to_hash}.to_h
    end
  end

  class Parameter < Treetop::Runtime::SyntaxNode
    def to_hash
      return self.elements.map {|x| x.to_hash}
    end
  end

  class Matrix < Treetop::Runtime::SyntaxNode
      def to_hash
          return self.elements[0].to_hash
      end
  end

  class NumberList < Treetop::Runtime::SyntaxNode
    def to_hash
      return self.elements.map {|x| x.to_hash}
    end
  end

  class SpacedNumber < Treetop::Runtime::SyntaxNode
    def to_hash
      return self.elements[0].to_hash
    end
  end

  class FloatLiteral < Treetop::Runtime::SyntaxNode
      def to_hash
          return self.text_value.to_f
      end
  end

  class IntegerLiteral < Treetop::Runtime::SyntaxNode
      def to_hash
          return self.text_value.to_i
      end
  end

  class StringLiteral < Treetop::Runtime::SyntaxNode
      def to_hash
          return eval self.text_value
      end
  end

  class Identifier < Treetop::Runtime::SyntaxNode
      def to_hash
          return self.text_value.to_sym
      end
  end

  class InputList < Treetop::Runtime::SyntaxNode
    def to_hash
      return self.elements.map {|x| x.to_hash}.to_h
    end
  end

  class Input < Treetop::Runtime::SyntaxNode
    def to_hash
      return [
        self.elements[0].to_hash,
        {
          :index => self.elements[0].to_hash,
          :parameters => self.elements[1].to_hash,
          :membership => self.elements.fetch(2, {}).to_hash
        }
      ]
    end
  end

  class Index < Treetop::Runtime::SyntaxNode
    def to_hash
      return self.text_value.to_i
    end
  end


  class MembershipList < Treetop::Runtime::SyntaxNode
      def to_hash
          return self.elements.map {|x| x.to_hash}.to_h
      end
  end

  class Membership < Treetop::Runtime::SyntaxNode
    def to_hash
      return [
        self.elements[0].to_hash,
        {
          :index => self.elements[0].to_hash,
          :name => self.elements[1].to_hash,
          :type => self.elements[2].to_hash,
          :parameters => self.elements[3].to_hash
        }
      ]
    end
  end

  class OutputList < Treetop::Runtime::SyntaxNode
    def to_hash
      return self.elements.map {|x| x.to_hash}.to_h
    end
  end

  class Output < Treetop::Runtime::SyntaxNode
    def to_hash
      return [
        self.elements[0].to_hash,
        {
          :index => self.elements[0].to_hash,
          :parameters => self.elements[1].to_hash,
          :membership => self.elements[2].to_hash
        }
      ]
    end
  end

  class Rules < Treetop::Runtime::SyntaxNode
    def to_hash
      return self.elements[0].to_hash
    end
  end

  class RuleList < Treetop::Runtime::SyntaxNode
    def to_hash
      return self.elements.map {|x| x.to_hash}
    end
  end

  class FuzzyRule < Treetop::Runtime::SyntaxNode
    def to_hash
      return {
        :antecedent => self.elements[0].to_hash,
        :consequent => self.elements[1].to_hash,
        :weight => self.elements[2].to_hash,
        :connective => self.elements[3].to_hash
      }
    end
  end

  class IndexList < Treetop::Runtime::SyntaxNode
      def to_hash
          return self.elements.map {|x| x.to_hash}
      end
  end

  class SpacedInteger < Treetop::Runtime::SyntaxNode
      def to_hash
          return self.elements[0].to_hash
      end
  end
end
