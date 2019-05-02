require "./zhen_xiang/**"

module ZhenXiang
  VERSION = "0.1.0-dev"

  def self.start
    CLI::Parser.run
    Web.start
  end
end

ZhenXiang.start unless (ENV["ZHENXIANG_ENV"]? && (ENV["ZHENXIANG_ENV"] == "test"))
