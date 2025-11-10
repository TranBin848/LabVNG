class_name JsonHelper extends Node

static func parse(s: String) -> Dictionary:
	var json = JSON.new()
	var return_code = json.parse(s)
	
	if return_code != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", s, " at line ", json.get_error_line())
		return {}
		
	var json_obj = json.data
	if typeof(json_obj) != TYPE_DICTIONARY:
		print("Only support JSON Dictionary")
		return {}
		
	return json_obj
