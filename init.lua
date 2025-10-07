require("config.options")
require("config.custom_commands")
require("config.keymaps")
require("config.lazy")
require("config.event_listeners")
if init_debug then
	require("osv").launch({ port = 8086, blocking = true })
end
