module UFuzzyConvert

  module Exporter

    class TxtExporter
      def self.export(data, destination, open_function=File.open)
        open_function.call(destination, 'w') do |output|
          line_break = "\n"
          hex = ""
          byte_count = 0
          data.each do |byte|
            hex << "0x%.2xu," % byte

            byte_count += 1
            hex << (byte_count % 11 == 0 ? line_break : ' ')
          end

          hex.chomp! line_break
          hex.chomp! " "
          hex.chomp! ","

          output.write hex
        end
      end
    end
  end
end
