-- Load packaged modules from the shared resource root on both platforms.
package.path = rime_api.get_shared_data_dir() .. "/?.lua;" .. package.path
tone_filter = require("tone_filter")
