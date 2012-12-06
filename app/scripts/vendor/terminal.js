// Adapted from
// http://www.html5rocks.com/en/tutorials/file/filesystem/terminal.js

var util = util || {};
util.toArray = function(list) {
  return Array.prototype.slice.call(list || [], 0);
};

var Terminal = Terminal || function(cmdLineContainer, outputContainer) {
  window.URL = window.URL || window.webkitURL;
  window.requestFileSystem = window.requestFileSystem ||
                             window.webkitRequestFileSystem;

  var cmdLine_ = document.querySelector(cmdLineContainer);
  var output_ = document.querySelector(outputContainer);
  const VERSION_ = '0.0.1';
  const CMDS_ = [ /* 'a', 'add','addx', 'archive','lately', 'mit','nav', 'rm', 'depri', 'do'*/
    'clear', 'date', 'help', 'ls', 'theme', 'version', 'who'
  ];
  const THEMES_ = ['default', 'cream'];
  var fs_ = null;
  var cwd_ = null;
  var history_ = [];
  var histpos_ = 0;
  var histtemp_ = 0;

  window.addEventListener('click', function(e) {
    cmdLine_.focus();
  }, false);

  // Always force text cursor to end of input line.
  cmdLine_.addEventListener('click', inputTextClick_, false);

  // Handle up/down key presses for shell history and enter for new command.
  cmdLine_.addEventListener('keydown', historyHandler_, false);
  cmdLine_.addEventListener('keydown', processNewCommand_, false);

  function inputTextClick_(e) {
    this.value = this.value;
  }

  function historyHandler_(e) { // Tab needs to be keydown.

    if (history_.length) {
      if (e.keyCode == 38 || e.keyCode == 40) {
        if (history_[histpos_]) {
          history_[histpos_] = this.value;
        } else {
          histtemp_ = this.value;
        }
      }

      if (e.keyCode == 38) { // up
        histpos_--;
        if (histpos_ < 0) {
          histpos_ = 0;
        }
      } else if (e.keyCode == 40) { // down
        histpos_++;
        if (histpos_ > history_.length) {
          histpos_ = history_.length;
        }
      }

      if (e.keyCode == 38 || e.keyCode == 40) {
        this.value = history_[histpos_] ? history_[histpos_] : histtemp_;
        this.value = this.value; // Sets cursor to end of input.
      }
    }
  }

  function processNewCommand_(e) {

    if (e.keyCode == 9) { // tab
      e.preventDefault();
      // TODO(ericbidelman): Implement tab suggest.
    } else if (e.keyCode == 13) { // enter

      // Save shell history.
      if (this.value) {
        history_[history_.length] = this.value;
        histpos_ = history_.length;
      }

      // Duplicate current input and append to output section.
      var line = this.parentNode.parentNode.cloneNode(true);
      line.removeAttribute('id')
      line.classList.add('line');
      var input = line.querySelector('input.cmdline');
      input.autofocus = false;
      input.readOnly = true;
      output_.appendChild(line);

      // Parse out command, args, and trim off whitespace.
      // TODO(ericbidelman): Support multiple comma separated commands.
      if (this.value && this.value.trim()) {
        var args = this.value.split(' ').filter(function(val, i) {
          return val;
        });
        var cmd = args[0].toLowerCase();
        args = args.splice(1); // Remove cmd from arg list.
      }

      switch (cmd) {
        case 'clear':
          output_.innerHTML = '';
          this.value = '';
          return;
        case 'date':
          output((new Date()).toLocaleString());
          break;
        case 'help':
          output('<div class="ls-files">' + CMDS_.join('<br>') + '</div>');
          output('<p>Add files by dragging them from your desktop.</p>');
          break;
        case 'a':
        case 'add':
          add(args);
          break;
        case 'ls':
          ls(args);
          break;
        case 'do':
          doTask(args);
          break;
        case 'ls2':
          ls_(function(entries) {
            if (entries.length) {
              var html = formatColumns_(entries);
              util.toArray(entries).forEach(function(entry, i) {
                html.push(
                    '<span class="', entry.isDirectory ? 'folder' : 'file',
                    '">', entry.name, '</span><br>');
              });
              html.push('</div>');
              output(html.join(''));
            }
          });
          break;
        case 'theme':
          var theme = args.join(' ');
          if (!theme) {
            output(['usage: ', cmd, ' ' + THEMES_.join('|')].join(''));
          } else {
            var matchedThemes = THEMES_.join('|').match(theme);
            if (matchedThemes && matchedThemes.length) {
              setTheme_(theme);
            } else {
              output('Error - Unrecognized theme used');
            }
          }
          break;
        case 'version':
        case 'ver':
          output(VERSION_);
          break;
        case 'who':
          output(document.title +
                 ' - By: James Williams &lt;james.l.williams@gmail.com&gt;');
          break;
        default:
          if (cmd) {
            output(cmd + ': command not found');
          }
      };

      window.scrollTo(0, getDocHeight_());
      this.value = ''; // Clear/setup line for next input.
    }
  }
  
  function add(args) {
    var task = new Task(args.join(' '))
    app.todos.list.push(task)
    app.term.output(app.todos.list.length+ ' '+task.raw()+'<br/>');
    app.term.output('TODO: '+app.todos.list.length+ ' added.<br/>');
  }

  function doTask(args) {
    var num = args[0]
    task = app.todos.list[num-1]
    task.markAsDone()
    app.term.output(num +' '+task.toString()+'<br/>');
    app.term.output('TODO: '+num+ ' marked as done.<br/>');
    app.term.output(task+'<br/>');
    console.log(task);
    // Archive task
  }

  function ls(args) {
    console.log('args:'+args);
    if (args.length == 0) {
      var self = this;
      i = 1
      _.each(app.todos.list, function(it) { 
        // pad zeros
        if (i < 10)
          ii = '0' + i
        else ii = ""+i
        app.term.output(ii + ' '+it.raw() + '<br/>')
        i++;
      });
      app.term.output('-- <br/>');
      app.term.output('TODO: ' + (i-1) +' of '+ app.todos.list.length + ' tasks shown<br/>');
    } else if (args[0].indexOf('+')==0) {
      console.log(app.todos.byProject(args[0]));
    } else if (args[0].indexOf('@')==0) {
      console.log(app.todo.byContext(args[0]));
    } else {

    }
  }

  function formatColumns_(entries) {
    var maxName = entries[0].name;
    util.toArray(entries).forEach(function(entry, i) {
      if (entry.name.length > maxName.length) {
        maxName = entry.name;
      }
    });

    // If we have 3 or less entires, shorten the output container's height.
    // 15 is the pixel height with a monospace font-size of 12px;
    var height = entries.length <= 3 ?
        'height: ' + (entries.length * 15) + 'px;' : '';

    // 12px monospace font yields ~7px screen width.
    var colWidth = maxName.length * 7;

    return ['<div class="ls-files" style="-webkit-column-width:',
            colWidth, 'px;', height, '">'];
  }

  function errorHandler_(e) {
    var msg = '';
    switch (e.code) {
      default:
        msg = 'Unknown Error';
        break;
    };
    output('<div>Error: ' + msg + '</div>');
  }



  function ls_(successCallback) {
    if (!fs_) {
      return;
    }

    // Read contents of current working directory. According to spec, need to
    // keep calling readEntries() until length of result array is 0. We're
    // guarenteed the same entry won't be returned again.
    var entries = [];
    var reader = cwd_.createReader();

    var readEntries = function() {
      reader.readEntries(function(results) {
        if (!results.length) {
          successCallback(entries.sort());
        } else {
          entries = entries.concat(util.toArray(results));
          readEntries();
        }
      }, errorHandler_);
    };

    readEntries();
  }

  function setTheme_(theme) {
    var currentUrl = document.location.pathname;

    if (!theme || theme == 'default') {
      //history.replaceState({}, '', currentUrl);
      chrome.storage.local.remove('theme');
      document.body.className = '';
      return;
    }

    if (theme) {
      document.body.classList.add(theme);
      chrome.storage.local.set('theme', theme);
      //history.replaceState({}, '', currentUrl + '#theme=' + theme);
    }
  }

  function output(html) {
    output_.insertAdjacentHTML('beforeEnd', html);
  }

  // Cross-browser impl to get document's height.
  function getDocHeight_() {
    var d = document;
    return Math.max(
        Math.max(d.body.scrollHeight, d.documentElement.scrollHeight),
        Math.max(d.body.offsetHeight, d.documentElement.offsetHeight),
        Math.max(d.body.clientHeight, d.documentElement.clientHeight)
    );
  }

  return {
    initFS: function(persistent, size) {
      output('<div>Welcome to ' + document.title +
             '! (v' + VERSION_ + ')</div>');
      output((new Date()).toLocaleString());
      output('<p>Documentation: type "help"</p>');

      if (!!!window.requestFileSystem) {
        output('<div>Sorry! The FileSystem API is not available in your browser.</div>');
        return;
      }

      var type = persistent ? window.PERSISTENT : window.TEMPORARY;
      window.requestFileSystem(type, size, function(filesystem) {
        fs_ = filesystem;
        cwd_ = fs_.root;

        // Attempt to create a folder to test if we can.
        cwd_.getDirectory('testquotaforfsfolder', {create: true}, function(dirEntry) {
          dirEntry.remove(function() { // If successfully created, just delete it.
            // noop.
          });
        }, function(e) {
          if (e.code == FileError.QUOTA_EXCEEDED_ERR) {
            output('ERROR: Write access to the FileSystem is unavailable. ' +
                   'Are you running Google Chrome with ' + 
                   '--unlimited-quota-for-files?');
          } else {
            errorHandler_(e);
          }
        });

      }, errorHandler_);
    },
    output: output,
    setTheme: setTheme_
  }
};
