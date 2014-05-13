linterPath = atom.packages.getLoadedPackage("linter").path
#console.log linterPath
Linter = require "#{linterPath}/lib/linter"

class LinterPclint extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.c', 'source.cpp']

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: 'flint -b -v -hF1 -width\[0\] -format="%t:%f:%l:%c:%n %m"'

  executablePath: null

  linterName: 'flint'

  # A regex pattern used to extract information from the executable's output.
  regex: '((?<error>Error)|(?<warning>Warning)):(?<file>.*):(?<line>[0-9]+):(?<col>[0-9]+):(?<message>.*)'
  #regex: '.*line="(?<line>[0-9]+)" column="(?<col>[0-9]+)" severity="((?<error>error)|(?<warning>warning))" message="(?<message>.*)" source'

  standard: null

  constructor: (editor)->
    super(editor)

    atom.config.observe 'linter-pclint.pclintExecutablePath', =>
      @executablePath = atom.config.get 'linter-pclint.pclintExecutablePath'

    atom.config.observe 'linter-pclint.standard', =>
      @standard = atom.config.get 'linter-pclint.standard'

  destroy: ->
    atom.config.unobserve 'linter-pclint.pclintExecutablePath'
    atom.config.unobserve 'linter-pclint.standard'

  getCmd:(filePath) ->
    cmd = super(filePath)
    cmd.replace('@standard', @standard)

module.exports = LinterPclint
