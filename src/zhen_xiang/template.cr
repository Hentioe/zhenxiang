require "digest"
require "crinja"

module ZhenXiang
  class Template
    @tpl_video : String
    @tpl_ass : String

    def initialize(tpl_video, tpl_ass)
      if File.exists?(tpl_video) && File.exists?(tpl_ass)
        @tpl_video = tpl_video
        @tpl_ass = File.read(tpl_ass)
      else
        raise "created a template object that does not exist"
      end
    end

    def output(subtitles, format, path)
      # 创建字幕模板
      env = Crinja.new
      template = env.from_string @tpl_ass
      # 渲染字幕模板内容
      ass_content = template.render({"sentences" => subtitles})
      # 获取字幕内容 hash
      hash = Digest::MD5.hexdigest(ass_content)[0..8]
      # 储存字幕模板
      ass_path = "outputs/#{hash}.ass"
      File.write ass_path, ass_content, mode: "w"
      # 输出命令
      args =
        case format
        when :mp4
          ["-i", @tpl_video, "-vf", "ass=#{ass_path}", "-an", "-y", "#{path}/#{hash}.mp4"]
        when :gif
          ["-i", @tpl_video, "-vf", "ass=#{ass_path},scale=300:-1", "-r", "8", "-y", "#{path}/#{hash}.gif"]
        else
          raise "unsupported output format: #{format}"
        end
      Process.run("ffmpeg", args: args)
    end
  end
end
