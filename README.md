# µfuzzyconvert

µfuzzyconvert is a tool for converting FIS files used by MATLAB to CFS format,
a lightweight binary format used by
[µFuzzy](http://bitbucket.org/fsalinasmendoza/fuzzy).

## Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

### Prerequisites

µfuzzyconvert requires Ruby and was tested against Ruby 2.1.5. On Windows
machines, Ruby can be installed using
[RubyInstaller](https://rubyinstaller.org/downloads/). On Linux machines, it can
be installed using a package management system such as apt:

```bash
apt-get install ruby
```

µfuzzyconvert uses bundler to handle dependencies. It can be installed running:

```bash
gem install bundler
```

If you plan to generate run the tests or generate the documentation then you
need to install the Ruby development kit. The windows version can be downloaded
from the [RubyInstaller website](https://rubyinstaller.org/downloads/). On Linux
machines it can be installed running:

```bash
apt-get install ruby-dev
```

### Installing

µfuzzyconvert can be downloaded using git.

```bash
git clone https://github.com/fsalinasmendoza/µfuzzyconvert.git
```

After that, run in the project directory:

```bash
bundler install --without development
```

If you want the development version, run instead:

```bash
bundler install
```

### Running the converter

FIS files can be converted running:

```bash
bundler exec exe/ufuzzyconvert [-d dsteps] [-s tsize] [-f format] SOURCE [DESTINATION]
```

where:

- `-d, --dsteps=<i>` Defines the number of defuzzification steps as `2^dsteps.` The default value is 8 which implies a 256 steps defuzzification process. The maximum value is 14 (16384 steps).
- `-s, --tsize=<i>` Defines the membership function table size as `2^tsize`. The default value is 8 which implies tables with 256 entries. The maximum value is 14 (16384 entries).
- `-f, --format=<s>` Selects the output format. Supported formats are `c`, `cfs` and `txt`. The default format is `txt`
- `SOURCE` Specifies the input FIS file.
- `DESTINATION` Specifies the output file. If `DESTINATION` is not defined, the output file is created in the working directory, and receives the same name as the source file with the extension of the selected format.


## Running the tests

To run one test at the time:

```bash
rake test TEST=path_to_the_test
```

For example:

```bash
rake test TEST=test/test_fuzzy_system.rb
```

To run all unit tests:

```bash
rake test [-v]
```

To run the integration test:

```bash
rake test:integration [-v]
```

To run all the tests:

```bash
rake test:all [-v]
```

## Generating the documentation

To generate the documentation run:

```bash
rake yard
```

## License

This project is licensed under the MIT License - see the
[LICENSE.md](LICENSE.md) file for details
