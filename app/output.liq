# Output Module
# Handles Icecast output and metadata updates

def send_url_metadata(m) =
  cover_url = m["url"] ?? ""
  if cover_url != "" and cover_url != radio_url then
    log("Sending StreamUrl to Icecast: #{cover_url}")
    icy.update_metadata(
      host=icecast_host,
      port=icecast_port,
      password=icecast_password,
      mount="/#{icecast_mount}",
      [("url", cover_url)]
    )
  end
end

def setup_output(radio) =
  # Register callback to send url after each metadata change
  radio.on_metadata(send_url_metadata)

  # Output to Icecast-KH
  output.icecast(
    get_encoder(),
    host=icecast_host,
    port=icecast_port,
    password=icecast_password,
    mount=icecast_mount,
    name=radio_name,
    description=radio_description,
    genre=radio_genre,
    url=radio_url,
    public=true,
    send_icy_metadata=true,
    radio
  )

  log("Stream started successfully!")
  log("Icecast: http://#{icecast_host}:#{icecast_port}/#{icecast_mount}")
  if harbor_enabled then
    log("Harbor (live input): ENABLED on port #{harbor_port}, user: #{harbor_user}")
  else
    log("Harbor (live input): DISABLED")
  end
  if telnet_enabled then
    log("Telnet control: ENABLED on port #{telnet_port}")
  else
    log("Telnet control: DISABLED")
  end
end

log("Output: Module loaded")
