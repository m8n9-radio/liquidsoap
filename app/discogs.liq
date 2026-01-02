# Discogs Album Cover Fetching Module
# Fetches album covers from Discogs API with caching

# Initialize cache
discogs_cache = ref([])

def get_discogs_cover(artist, title, album) =
  if not discogs_enabled or discogs_token == "" then
    ""
  else
    cache_key = "#{artist}|#{title}|#{album}"
    cache = discogs_cache()
    cached = list.assoc(default="", cache_key, cache)

    if cached != "" then
      log.critical("============================================================")
      log.critical("Discogs: [CACHE HIT] Using cached cover for [#{artist} - #{title}]")
      log.critical("============================================================")
      cached
    else
      # Try simple query first - works better than strict field matching
      query = "#{artist} #{title}"

      encoded = url.encode(query)
      api_url = "https://api.discogs.com/database/search?q=#{encoded}&type=release&per_page=1&token=#{discogs_token}"

      try
        cmd = "curl -s '#{api_url}' | jq -r '.results[0].cover_image // empty'"
        result = list.hd(default="", process.read.lines(cmd))
        cover = string.trim(result)

        if cover != "" and cover != "null" then
          log.critical("============================================================")
          log.critical("Discogs: [FOUND] Cover for [#{artist} - #{title}] - URL: #{cover}")
          log.critical("============================================================")

          cache_size = list.length(cache)
          updated_cache = if cache_size >= discogs_cache_max_size then
            log.critical("============================================================")
            log.critical("Discogs: [CACHE] Limit reached (#{discogs_cache_max_size}), removing oldest entry")
            log.critical("============================================================")
            list.tl(cache)
          else
            cache
          end

          discogs_cache := list.add((cache_key, cover), updated_cache)

          if cache_size mod 100 == 0 and cache_size > 0 then
            log.critical("============================================================")
            log.critical("Discogs: [CACHE STATS] #{cache_size} entries")
            log.critical("============================================================")
          end

          cover
        else
          log.critical("============================================================")
          log.critical("Discogs: [NOT FOUND] No cover for [#{artist} - #{title}]")
          log.critical("============================================================")

          msg = "<b>🎵 No Cover</b>\n\n<b>Artist:</b> #{artist}\n<b>Title:</b> #{title}\n<b>Album:</b> #{album}"
          send_telegram(msg)

          updated_cache = if list.length(cache) >= discogs_cache_max_size then
            list.tl(cache)
          else
            cache
          end

          discogs_cache := list.add((cache_key, ""), updated_cache)
          ""
        end
      catch err do
        log.critical("============================================================")
        log.critical("Discogs: [ERROR] API error: #{err}")
        log.critical("============================================================")
        ""
      end
    end
  end
end

log.critical("============================================================")
log.critical("Discogs: Module loaded successfully")
log.critical("============================================================")
