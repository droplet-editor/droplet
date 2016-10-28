var modes = require('./modes.coffee');

runningModes = {};

console.log('Worker starting up.');

onmessage = function(e) {
  var data = e.data;

  if (data.command === 'initMode') {
    runningModes[data.id] = new modes[data.mode](data.modeOptions);
  }
  else if (data.command === 'preparse') {
    if (data.id in runningModes && runningModes[data.id].preparse != null) {
      try {
        var result = runningModes[data.id].preparse(data.text, data.context);
        postMessage({
          id: data.id,
          result: result
        });
      }
      catch (e) {
        postMessage({
          id: data.id,
          result: null
        });
      }
    } else {
      postMessage({
        id: data.id,
        result: null
      });
    }
  }
};
