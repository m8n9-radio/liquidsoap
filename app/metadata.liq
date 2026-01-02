# Metadata Processing Module
# Processes track metadata, fetches covers, and prepares for streaming

def process_metadata(m) =
  artist = m["artist"] ?? ""
  title = m["title"] ?? ""
  album = m["album"] ?? ""
  filename = m["filename"] ?? "Unknown"
  is_jingle = m["is_jingle"] ?? "false"

  if artist == "" or title == "" then
    log.critical("============================================================")
    log.critical("Metadata: [WARNING] Missing metadata for file: #{filename}")
    log.critical("============================================================")
    artist_display = if artist == "" then "MISSING" else artist end
    title_display = if title == "" then "MISSING" else title end
    msg = "<b>⚠️ Missing Metadata</b>\n\n<b>File:</b> #{filename}\n<b>Artist:</b> #{artist_display}\n<b>Title:</b> #{title_display}"
    send_telegram(msg)
  end

  # Get cover from Discogs (or empty string if disabled/not found)
  cover = if artist != "" and (title != "" or album != "") then
    get_discogs_cover(artist, title, album)
  else
    ""
  end

  # Calculate MD5 hash from filename for unique ID
  md5sum = try
    md5_cmd = "echo -n '#{filename}' | md5sum | cut -d' ' -f1"
    string.trim(list.hd(default="", process.read.lines(md5_cmd)))
  catch e do
    log.critical("============================================================")
    log.critical("Metadata: [MD5 ERROR] Error calculating hash for #{filename}: #{e}")
    log.critical("============================================================")
    ""
  end

  # Send track data to backend (with md5sum, cover) - exclude jingles and tracks without metadata
  if is_jingle != "true" and artist != "" and title != "" then
    send_to_backend(artist, title, cover, md5sum)
  else
    if is_jingle == "true" then
      log.critical("============================================================")
      log.critical("Metadata: [JINGLE] Detected - skipping backend transmission")
      log.critical("============================================================")
    else
      log.critical("============================================================")
      log.critical("Metadata: [SKIP] Missing metadata - skipping backend transmission")
      log.critical("============================================================")
    end
  end

  # Build stream_title with md5sum for Icecast
  base_title = if artist != "" and title != "" then
    "#{artist} - #{title}"
  elsif title != "" then
    title
  else
    radio_name
  end

  stream_title = if md5sum != "" then
    "#{base_title} [#{md5sum}]"
  else
    base_title
  end

  stream_url = if cover != "" then cover else radio_url end

  [
    ("artist", ""),
    ("title", stream_title),
    ("url", stream_url)
  ]
end

log.critical("============================================================")
log.critical("Metadata: Module loaded successfully")
log.critical("============================================================")
