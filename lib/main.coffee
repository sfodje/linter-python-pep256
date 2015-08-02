{BufferedProcess, CompositeDisposable} = require 'atom'

module.exports =
  config:
    executablePath:
      type: 'string'
      default: 'pep257'
      description: "Path to executable pep257 cmd."
    ignoreCodes:
      type: 'string'
      default: ''
      description: ('Comma separated list of error codes to ignore. ' +
        'Available codes: https://pypi.python.org/pypi/pep257#error-codes')

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'linter-python-pep257.executablePath',
      (executablePath) =>
        @executablePath = executablePath
    @subscriptions.add atom.config.observe 'linter-python-pep257.ignoreCodes',
      (executablePath) =>
        @executablePath = executablePath
    console.log 'activate linter-python-pep257'
  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      grammarScopes: ['source.python']
      scope: 'file' # or 'project'
      lintOnFly: true # must be false for scope: 'project'
      lint: (textEditor)->
        return new Promise (resolve, reject) =>
          filePath = textEditor.getPath()
          cmd = atom.config.get('linter-python-pep257.executablePath')
          parameters = [filePath, "--count"]
          if ignoreCodes = atom.config.get('linter-python-pep257.ignoreCodes')
            parameters.push("--ignore=#{ignoreCodes}")
          info = {}
          process = new BufferedProcess
            command: cmd
            args: parameters
            stdout: (data) ->
              info.error_count = data
            stderr: (data) ->
              info.errors = data
            exit: (code) ->
              return resolve [] if code is 0
              return resolve [] if info.error_count is 0
              output = info.errors.split "\n"
              messages = []
              for v, k in output
                if k % 2 is 0 and k < output.length - 1
                  line_number = parseInt (v.match(/:\d+/) || [":"])[0].split(":")[1]
                  line_number -= 1
                  l = k + 1
                  msg = output[k].trim() + " " + output[l].trim()
                  if parseInt(line_number) != line_number
                    resolve []
                  messages.push {
                    type: 'Warning',
                    text: msg,
                    filePath: filePath,
                    range: [[line_number, 0], [line_number, 0]]
                  }
              resolve messages

          process.onWillThrowError ({error, handle}) ->
            atom.notifications.addError "Failed to run #{@executablePath}",
              detail: "#{error.message}"
              dismissable: true
            handle()
            resolve []
