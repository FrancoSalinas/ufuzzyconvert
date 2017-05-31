module UFuzzyConvert

  module Exporter

    class CExporter

      def self.header_contents(name, data)
        return <<-EOS
/* Copyright (c) 2017, Franco Javier Salinas Mendoza
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files(the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions :
 *
 *  The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#ifndef uF_GEN_#{name.upcase}_H
#define uF_GEN_#{name.upcase}_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

extern const uint8_t #{name.upcase}[#{data.length}];

#ifdef __cplusplus
}
#endif

#endif /* uF_GEN_#{name.upcase}_H */
EOS
      end

      def self.source_contents(name, data)
        return <<-EOS
/* Copyright (c) 2017, Franco Javier Salinas Mendoza
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files(the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions :
 *
 *  The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#include "#{name}.h"

const uint8_t #{name.upcase}[] = {
#{self.data_to_hex data}
};
EOS
      end

      def self.data_to_hex(data)
        line_break = "\n    "
        hex = "    "
        byte_count = 0
        data.each do |byte|
          hex << "0x%.2xu," % byte

          byte_count += 1
          hex << (byte_count % 11 == 0 ? line_break : ' ')
        end

        hex.chomp! line_break
        hex.chomp! " "
        hex.chomp! ","

        return hex
      end

      def self.export(data, dest, open_function=File.open)
        ext = File.extname dest
        base_name = File.basename(dest, ext)

        name_without_ext = ['.h', '.c'].include?(ext) ? dest.chomp(ext) : dest

        header_name = "#{name_without_ext}.h"
        source_name = "#{name_without_ext}.c"

        header_contents = self.header_contents base_name, data
        source_contents = self.source_contents base_name, data

        open_function.call(header_name, 'w') do |output|
          output.write header_contents
        end

        open_function.call(source_name, 'w') do |output|
          output.write source_contents
        end
      end
    end
  end
end
