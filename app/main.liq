#!/usr/bin/liquidsoap
# Main Entry Point
# Loads all modules and starts the radio stream

# 1. Configuration (must be first)
%include "config.liq"

log("============================================================")
log("Starting Liquidsoap Radio Stream")
log("============================================================")
log("Loading modules...")

# 2. Notification systems (used by other modules)
%include "telegram.liq"

# 3. External integrations
%include "backend.liq"
%include "discogs.liq"

# 4. Metadata processing (depends on telegram, backend, discogs)
%include "metadata.liq"

# 5. Audio sources (depends on metadata)
%include "sources.liq"

# 6. Encoder selection
%include "encoder.liq"

# 7. Output configuration (depends on all above)
%include "output.liq"

log("All modules loaded successfully")
log("============================================================")

# Create the radio source
radio = create_sources()

# Setup output
setup_output(radio)

log("============================================================")
log("Radio stream is now live!")
log("============================================================")
