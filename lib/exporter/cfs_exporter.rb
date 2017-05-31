module UFuzzyConvert

  module Exporter

    class CfsExporter
      def self.export(data, destination, open_function=File.open)
        open_function.call(destination, 'wb') do |output|
          data.each do |byte|
            output.write byte.chr
          end
        end
      end
    end
  end
end
