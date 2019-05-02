require "digest"
require "crinja"

module ZhenXiang
  class Template
    getter video : String
    getter ass : String
    getter name : String
    getter path : String
    getter subtitles : Array(String)

    def initialize(video, ass, name, subtitles)
      if File.exists?(video) && File.exists?(ass)
        @video = video
        @ass = File.read ass
        @name = name.strip
        @path = File.basename File.dirname(video)
        @subtitles = subtitles
      else
        raise "created a template object that does not exist"
      end
    end

    def output(subtitles, format, path)
      # 创建字幕模板
      env = Crinja.new
      template = env.from_string @ass
      # 渲染字幕模板内容
      ass_content = template.render({"sentences" => subtitles})
      # 获取字幕内容 hash
      hash = Digest::MD5.hexdigest(ass_content)[0..8]
      # 储存字幕模板
      ass_path = "#{path}/#{hash}.ass"
      File.write ass_path, ass_content, mode: "w"
      # 输出命令
      args =
        case format
        when :mp4
          ["-i", @video, "-vf", "ass=#{ass_path}", "-an", "-y", "#{path}/#{hash}.mp4"]
        when :gif
          ["-i", @video, "-vf", "ass=#{ass_path},scale=300:-1", "-r", "8", "-y", "#{path}/#{hash}.gif"]
        else
          raise "unsupported output format: #{format}"
        end
      Process.run("ffmpeg", args: args)
    end
  end
end
