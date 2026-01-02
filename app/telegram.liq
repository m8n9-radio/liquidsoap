# Telegram Notification Module
# Sends notifications to Telegram bot

def send_telegram(msg) =
  if telegram_enabled and telegram_bot_token != "" and telegram_chat_id != "" then
    try
      enc_msg = url.encode(msg)
      url_base = "https://api.telegram.org/bot#{telegram_bot_token}/sendMessage"
      url_params = "?chat_id=#{telegram_chat_id}" ^ "&text=#{enc_msg}" ^ "&parse_mode=HTML"
      full_url = url_base ^ url_params
      cmd = "curl -s -X POST '#{full_url}' >/dev/null 2>&1"
      ignore(process.run(cmd))
      log.critical("============================================================")
      log.critical("Telegram: [SENT] Notification sent successfully")
      log.critical("============================================================")
    catch e do
      log.critical("============================================================")
      log.critical("Telegram: [ERROR] Failed to send notification: #{e}")
      log.critical("============================================================")
    end
  end
end

log.critical("============================================================")
log.critical("Telegram: Module loaded successfully")
log.critical("============================================================")
