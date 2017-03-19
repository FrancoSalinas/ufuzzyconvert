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

```
apt-get install ruby
```

Also, ufuzzyconvert requires treetop which can be installed running:

```
gem install treetop
```

To run tests it is necessary to have mocha installed:

```
gem install mocha
gem install simplecov
```

To build documentation, yard must be installed:

```
gem install yard
```

### Installing

ufuzzyconvert can be downloaded using git.

```
git clone https://github.com/fsalinasmendoza/ufuzzyconvert.git
```

### Running the converter

FIS files can be converted running:

```
bin/ufuzzyconvert <file.fis>
```

Its should output the file 'output.cfs'.

## Running the tests

To run one test at the time:

```
ruby <path_to_the_test>
```

For example:

```
ruby test/test_fuzzy_system.rb
```

To run all the tests:

```
ruby test/test_all.rb
```

## License

This project is licensed under the MIT License - see the
[LICENSE.md](LICENSE.md) file for details
