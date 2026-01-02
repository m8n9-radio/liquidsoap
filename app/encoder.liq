# Encoder Selection Module
# Selects and configures the audio encoder based on stream format

def get_encoder() =
  format = string.lowercase(stream_format)

  if format == "mp3" then
    log("Using MP3 encoder: #{stream_bitrate}kbps @ #{stream_samplerate}Hz")
    %mp3(bitrate=stream_bitrate, samplerate=stream_samplerate, stereo=true)
  elsif format == "vorbis" or format == "ogg" then
    log("Using Vorbis encoder: #{stream_bitrate}kbps @ #{stream_samplerate}Hz")
    quality = float_of_int(stream_bitrate) / 64.0
    %vorbis(quality=quality, samplerate=stream_samplerate)
  elsif format == "opus" then
    log("Using Opus encoder: #{stream_bitrate}kbps @ #{stream_samplerate}Hz")
    %opus(bitrate=stream_bitrate, samplerate=stream_samplerate)
  else
    log("WARNING: Unknown format '#{format}', falling back to MP3")
    %mp3(bitrate=stream_bitrate, samplerate=stream_samplerate, stereo=true)
  end
end

log("Encoder: Module loaded")
