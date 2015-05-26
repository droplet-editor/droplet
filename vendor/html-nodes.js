define(["exports"], function(exports)
{
	exports.textNode = function(location)
	{
		this.type = "text";
		this.location = location;
	}
	exports.commentNode = function(location)
	{
		this.type = "comment";
		this.location = location;
	}
	exports.tagNode = function(type, name, location)
	{
		this.type = type + "Tag";
		this.name = name;
		this.location = location;
		this.attribsSet = false;
	}
	exports.blockNode = function(startTag)
	{
		this.type = "blockTag";
		this.name = startTag.name;
		this.location = {start: startTag.location.start};
		this.consequent = {type: 'consequent'};
		this.consequent.location = {start: startTag.location.end};
		this.consequent.children = [];
		this.attribsSet = false;
	}
});