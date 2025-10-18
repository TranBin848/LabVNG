extends Node

## Save system for persistent checkpoint data
const SAVE_FILE: String = "user://checkpoint_save.dat"

# Save checkpoint data to file
func save_checkpoint_data(data: Dictionary) -> void:
	var file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open save file for writing")
		return
	
	# Convert Dictionary thành JSON và lưu
	var json_string: String = JSON.stringify(data)
	file.store_line(json_string)
	file.close()
	print("✅ Checkpoint data saved to file:", SAVE_FILE)


# Load checkpoint data from file
func load_checkpoint_data() -> Dictionary:
	if not has_save_file():
		print("⚠️ No save file found, starting fresh")
		return {}
	
	var file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		push_error("Failed to open save file for reading")
		return {}
	
	var json_string: String = file.get_as_text()
	file.close()
	
	var result: Variant = JSON.parse_string(json_string)
	if typeof(result) == TYPE_DICTIONARY:
		print("✅ Checkpoint data loaded from file")
		return result
	else:
		push_error("Failed to parse checkpoint data (invalid JSON)")
		return {}


# Check if save file exists
func has_save_file() -> bool:
	return FileAccess.file_exists(SAVE_FILE)


# Delete save file
func delete_save_file() -> void:
	if has_save_file():
		# Dùng DirAccess.remove_absolute để tránh lỗi kiểu Variant
		var error: Error = DirAccess.remove_absolute(SAVE_FILE)
		if error == OK:
			print("🗑️ Save file deleted")
		else:
			push_error("Failed to delete save file (Error code: %s)" % str(error))
