module UFuzzyConvert

  module Exporter

    class CfsExporter
      def self.export(data, destination, stream=File)
        stream.open(destination, 'wb') do |output|
          data.each do |byte|
            output.write byte.chr
          end
        end
      end
    end
  end
end
