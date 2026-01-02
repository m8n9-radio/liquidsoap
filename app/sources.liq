# Audio Sources Module
# Creates and configures playlists, live input, and audio processing

def create_sources() =
  # Songs playlist
  songs = playlist(
    mode="randomize",
    reload_mode="watch",
    "/app/storage/playlists/songs.m3u"
  )
  songs = mksafe(songs)
  songs = blank.skip(max_blank=5.0, min_noise=0.01, songs)
  songs = normalize(songs)
  songs = compress(songs)

  # Jingles playlist
  jingles = playlist(
    mode="randomize",
    reload_mode="watch",
    "/app/storage/playlists/jingles.m3u"
  )
  jingles = mksafe(jingles)
  jingles = blank.skip(max_blank=5.0, min_noise=0.01, jingles)
  jingles = normalize(jingles)
  jingles = compress(jingles)
  jingles = metadata.map(update=false, fun(_) -> begin
    [("title", "Jingle - Thanks for listening"), ("artist", ""), ("is_jingle", "true")]
  end, jingles)

  # Rotate between songs and jingles
  music = rotate(
    weights=[3, 1],
    [songs, jingles]
  )

  # Log current track
  music = metadata.map(update=false, fun(m) -> begin
    artist = m["artist"] ?? "Unknown"
    title = m["title"] ?? "Unknown"
    log.critical("============================================================")
    log.critical("Now playing: [#{artist} - #{title}]")
    log.critical("============================================================")
    m
  end, music)

  # Apply crossfade
  music = crossfade(
    duration=3.0,
    fade_in=1.5,
    fade_out=1.5,
    music
  )

  # Add live input if enabled
  radio = if harbor_enabled then
    log("Harbor (live input) enabled on port #{harbor_port}")
    live = input.harbor(
      "live.mp3",
      port=harbor_port,
      password=harbor_password,
      user=harbor_user
    )
    fallback(track_sensitive=false, [live, music, sine(440.0)])
  else
    log("Harbor (live input) disabled")
    fallback(track_sensitive=false, [music, sine(440.0)])
  end

  # Apply metadata processing
  radio = metadata.map(update=true, process_metadata, radio)

  radio
end

log("Sources: Module loaded")
