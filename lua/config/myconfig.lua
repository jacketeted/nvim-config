local screen_size = require("config.screen_size")
return {
	theme = "melange",
	background = screen_size.sm and "light" or "dark",
	cursor_color = screen_size.sm and "#555555" or "#CCCCCC",
	copilot_suggestion_color = screen_size.sm and "#AAAAAA" or "#555555",
	bottom_terminal_height = screen_size.sm and 8 or 10,
	auto_close_filetree = screen_size.sm,
}
