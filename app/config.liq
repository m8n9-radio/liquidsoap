# Configuration and Environment Variables
# Load all environment variables and configure Liquidsoap settings

# Telnet configuration
telnet_enabled = bool_of_string(environment.get("TELNET_ENABLED"))
telnet_port = int_of_string(environment.get("TELNET_PORT"))

# Logging configuration
log_level = int_of_string(environment.get("LOG_LEVEL"))

# Apply telnet settings
settings.server.telnet := telnet_enabled
settings.server.telnet.bind_addr := "0.0.0.0"
settings.server.telnet.port := telnet_port

# Apply logging settings
settings.log.level := log_level
settings.log.stdout := true

# Icecast configuration
icecast_host = environment.get("ICECAST_HOST")
icecast_port = int_of_string(environment.get("ICECAST_PORT"))
icecast_mount = environment.get("ICECAST_MOUNT")
icecast_password = environment.get("ICECAST_PASSWORD")

# Radio metadata
radio_name = environment.get("RADIO_NAME")
radio_description = environment.get("RADIO_DESCRIPTION")
radio_genre = environment.get("RADIO_GENRE")
radio_url = environment.get("RADIO_URL")

# Harbor (live input) configuration
harbor_enabled = bool_of_string(environment.get("HARBOR_ENABLED"))
harbor_port = int_of_string(environment.get("HARBOR_PORT"))
harbor_password = environment.get("HARBOR_PASSWORD")
harbor_user = environment.get("HARBOR_USER")

# Stream format configuration
stream_format = environment.get("STREAM_FORMAT")
stream_bitrate = int_of_string(environment.get("STREAM_BITRATE"))
stream_samplerate = int_of_string(environment.get("STREAM_SAMPLERATE"))

# Discogs API configuration
discogs_token = environment.get("DISCOGS_TOKEN")
discogs_enabled = bool_of_string(environment.get("DISCOGS_ENABLED"))
discogs_cache_max_size = int_of_string(environment.get("DISCOGS_CACHE_MAX_SIZE"))

# Telegram notification configuration
telegram_enabled = bool_of_string(environment.get("TELEGRAM_ENABLED"))
telegram_bot_token = environment.get("TELEGRAM_BOT_TOKEN")
telegram_chat_id = environment.get("TELEGRAM_CHAT_ID")

# Backend integration configuration
backend_enabled = bool_of_string(environment.get("BACKEND_ENABLED"))
backend_dns = environment.get("BACKEND_DNS")

log("Config: Environment variables loaded successfully")
