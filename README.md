# ufuzzyconvert

ufuzzyconvert is a tool for converting FIS files used by MATLAB to CFS format,
a lightweight binary format used by
[µFuzzy](http://bitbucket.org/fsalinasmendoza/fuzzy).

## Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

### Prerequisites

ufuzzyconvert requires Ruby and was tested against Ruby 2.1.5. On Windows
machines, Ruby can be installed using
[RubyInstaller](https://rubyinstaller.org/downloads/). On Linux machines, it can
be installed using a package management system such as apt:

```bash
apt-get install ruby
```

Also, ufuzzyconvert requires treetop and trollop. Both can be installed running:

```bash
gem install treetop
gem install trollop
```

To run tests it is necessary to have mocha installed:

```bash
gem install mocha
gem install simplecov
```

To build documentation, yard must be installed:

```bash
gem install yard
```

### Installing

ufuzzyconvert can be downloaded using git.

```bash
git clone https://github.com/fsalinasmendoza/ufuzzyconvert.git
```

### Running the converter

FIS files can be converted running:

```bash
ufuzzyconvert [-d dsteps] [-s tsize] [-f format] SOURCE [DESTINATION]
```

where:

- `-d, --dsteps=<i>` Defines the number of defuzzification steps as `2^dsteps.` The default value is 8 which implies a 256 steps defuzzification process.
- `-s, --tsize=<i>` Defines the membership function table size as `2^tsize`. The default value is 8 which implies tables with 256 entries.
- `-f, --format=<s>` Selects the output format. Supported formats are `c`, `cfs` and `txt`. The default format is `txt`
- `SOURCE` Specifies the input FIS file.
- `DESTINATION` Specifies the output file. If `DESTINATION` is not defined, the output file is created in the working directory, and receives the same name as the source file with the extension of the selected format. 


## Running the tests

To run one test at the time:

```bash
ruby <path_to_the_test>
```

For example:

```bash
ruby test/test_fuzzy_system.rb
```

To run all unit tests:

```bash
ruby test/test_all.rb
```

There is also an integration test that parses any FIS file in the `fis`
directory. This test does not generate output files. Run it with:

```bash
ruby test/integration.rb
```

## License

This project is licensed under the MIT License - see the
[LICENSE.md](LICENSE.md) file for details
