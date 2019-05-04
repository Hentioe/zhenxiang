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
      # 资源文件路径
      ass_file = "#{path}/#{hash}.ass"
      output_file = "#{path}/#{hash}.#{format}"
      # 可能存在资源
      if File.exists?(ass_file) && File.exists?(output_file)
        return hash
      end
      # 储存字幕模板
      File.write ass_file, ass_content, mode: "w"
      # 输出命令
      args =
        case format
        when :mp4
          ["-i", @video, "-vf", "ass=#{ass_file}", "-an", "-y", output_file]
        when :gif
          ["-i", @video, "-vf", "ass=#{ass_file},scale=300:-1", "-r", "8", "-y", output_file]
        else
          raise "unsupported output format: #{format}"
        end
      return hash if Process.run("ffmpeg", args: args).success?
    end
  end
end
