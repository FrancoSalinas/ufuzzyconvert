require 'treetop'

require_relative 'node_extensions.rb'

class Parser
  Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), 'fis_parser.treetop')))
	@@parser = FisParser.new

	def self.parse(data)
		tree = @@parser.parse(data)

		if(tree.nil?)
			raise Exception,
				"Parse error at offset: #{@@parser.index}\n" \
				"Reason: #{@@parser.failure_reason}\n"
		end

		self.clean_tree(tree)

		return tree.to_hash
	end
	private

		def self.clean_tree(root_node)
			return if(root_node.elements.nil?)
			root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
			root_node.elements.each {|node| self.clean_tree(node) }
		end
end
