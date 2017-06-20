module UFuzzyConvert

  module Exporter

    require_relative 'exception'

    require_relative 'exporter/c_exporter'
    require_relative 'exporter/cfs_exporter'
    require_relative 'exporter/txt_exporter'

    EXPORTERS_FROM_FORMAT = {
      'c' => CExporter,
      'cfs' => CfsExporter,
      'txt' => TxtExporter
    }

    def self.export(data, format, destination)
      begin
        EXPORTERS_FROM_FORMAT.fetch(format).export(data, destination)
      rescue KeyError
        raise FeatureError.new "Format #{format} not supported."
      end
    end

    def self.formats()
      return EXPORTERS_FROM_FORMAT.keys
    end
  end
end
