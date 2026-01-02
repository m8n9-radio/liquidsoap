# Backend Integration Module
# Sends track information to backend API

def send_to_backend(artist, title, cover, md5sum) =
  if backend_enabled and backend_dns != "" then
    try
      # Build track title as "Artist - Title"
      track_title = "#{artist} - #{title}"

      # Build backend URL
      backend_url = "#{backend_dns}/tracks"

      # Build JSON payload - escape quotes properly
      json_data = '{"Md5":"' ^ md5sum ^ '","StreamTitle":"' ^ track_title ^ '","StreamUrl":"' ^ cover ^ '"}'

      # Send POST request with JSON and capture HTTP status code
      cmd = "curl -s -w '%{http_code}' -o /dev/null -X POST '#{backend_url}' -H 'Content-Type: application/json' -d '#{json_data}'"
      status_code = string.trim(list.hd(default="000", process.read.lines(cmd)))
      log.critical("============================================================")
      log.critical("Backend: [#{status_code}] Sent [#{artist} - #{title}] (md5: #{md5sum})")
      log.critical("============================================================")
    catch e do
      log.critical("============================================================")
      log.critical("Backend: [ERROR] Sent [#{artist} - #{title}] (md5: #{md5sum}): Error - #{e}")
      log.critical("============================================================")
    end
  end
end

log("Backend: Module loaded")
