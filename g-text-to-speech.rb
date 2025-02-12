require 'net/http'
require 'optparse'
require 'fileutils'
require 'csv'
require 'base64'
require 'json'
require 'yaml'

class TextToSpeech
  def self.start(argv)
    opt = OptionParser.new
    params = {}
    opt.on('-f CSV') { |csv| params[:csv] = csv }
    opt.on('-t TEXT') { |text| params[:text] = text }
    opt.parse!(argv)

    if params[:csv]
      self.new.run_with_csv(params[:csv])
    elsif params[:text]
      self.new.run_with_text(params[:text])
    else
      raise '-f OR -t is required. See -h'
    end
  end

  def initialize
    uri = URI.parse('https://texttospeech.googleapis.com/v1beta1/text:synthesize')
    @http = Net::HTTP.new(uri.host, uri.port)
    @http.use_ssl = uri.scheme === "https"

    config = YAML.load(File.read(File.expand_path('config.yaml', __dir__)))
    credential_json = config['credential_json']

    @header = {
      "Authorization" => "Bearer #{access_token(credential_json)}",
      "Content-Type" => "application/json; charset=utf-8"
    }
  end

  def access_token(credential_json)
    `GOOGLE_APPLICATION_CREDENTIALS=#{File.expand_path(credential_json, __dir__)} gcloud auth application-default print-access-token`.chomp
  end

  def request(file, text)
    data = {
      "audioConfig" => {
        "audioEncoding" => "MP3",
        "pitch" => "0.00",
        "speakingRate" => "1.00"
      },
      "input" => {
        "text" => text
      },
      "voice" => {
        "languageCode" => "ja-JP",
        "name" => "ja-JP-Wavenet-B"
      }
    }

    json = JSON.dump(data)
    res = @http.post('/v1beta1/text:synthesize', json, @header)
    unless res.code == '200'
      raise res.body
    end
    result = JSON.parse(res.body)
    File.write(File.expand_path(file, __dir__), Base64.decode64(result['audioContent']))
  end

  def run_with_csv(csv_file)
    FileUtils.mkdir_p(File.expand_path("mp3", __dir__))

    CSV.read(csv_file).each do |row|
      raise "データが2列ではありません。: #{row}" unless row.size == 2
      next if row[0].nil?
      file = "mp3/#{row[0]}.mp3"
      text = row[1]
      puts "Request: #{file}"
      request(file, text)
    end
  end

  def run_with_text(text)
    FileUtils.mkdir_p(File.expand_path("mp3", __dir__))
      file = "mp3/result.mp3"
      puts "Request: #{file}"
      request(file, text)
  end
end

TextToSpeech.start(ARGV)
