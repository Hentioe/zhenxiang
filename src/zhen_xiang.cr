require "./zhen_xiang/**"

module ZhenXiang
  VERSION = "0.1.0-dev"

  def self.start
    CLI::Parser.run
    config = CLI::Config.instance
    scanning config.rpath
    Web.start
  end

  def self.scanning(rpath)
    Dir["#{rpath}/*"].select do |dir|
      [
        "#{dir}/template.mp4",
        "#{dir}/template.ass",
        "#{dir}/METADATA",
      ].select { |path| File.exists? path }.size == 3
    end
  end
end

ZhenXiang.start unless (ENV["ZHENXIANG_ENV"]? && (ENV["ZHENXIANG_ENV"] == "test"))
