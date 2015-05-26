define(["exports"], function(exports)
{
	exports.Stack = function(){

		arr = [];
		text = [];
		whitespace = [' ', '\n', '\t'];

		this.push = function(node)
		{
			arr[arr.length - 1].consequent.children.push(node);
		}

		this.start = function(node)
		{
			arr.push(node);
		}

		this.end = function(endLocation)
		{
			while(text[endLocation.start-1] != '\n' && /\s/.test(text[endLocation.start-1]))
				endLocation.start -= 1;
			if(text[endLocation.start-1] == '\n')
				endLocation.start -= 1;
			arr[arr.length - 1].location.end = endLocation.end;
			arr[arr.length - 1].consequent.location.end = endLocation.start;
			arr[arr.length - 2].consequent.children.push(arr[arr.length - 1]);
			arr = arr.slice(0, arr.length - 1);
		}

		this.top = function()
		{
			return arr[arr.length - 1];
		}

		this.debug = function()
		{
			console.log(arr, arr.length);
			for (var i = arr.length - 1; i >= 0; i--) {
				console.log(arr[i].name);
			};
		}

		this.clear = function()
		{
			arr = [];
			this.set_html('');
		}

		this.length = function()
		{
			return arr.length;
		}

		this.set_html = function(html)
		{
			text = html;
		}
	}
});