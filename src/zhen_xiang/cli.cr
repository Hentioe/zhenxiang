require "admiral"

module ZhenXiang::CLI
  DEFAULT_PROD  = false
  DEFAULT_PORT  = 8080
  DEFAULT_RPATH = "_res"
  DEFAULT_OPATH = "outputs"

  class Config
    @@instance = Config.new

    getter prod = DEFAULT_PROD
    getter port = DEFAULT_PORT
    getter rpath = DEFAULT_RPATH
    getter opath = DEFAULT_OPATH

    def initialize
    end

    private def initialize(@prod, @port, @rpath, @opath)
    end

    def self.init(flags)
      @@instance = self.new(
        flags.prod,
        flags.port,
        flags.resources_path,
        flags.output_path
      )
    end

    def self.instance
      @@instance
    end
  end

  class Parser < Admiral::Command
    define_help description: "我从这儿跳下去也不吃你们东西！"

    define_flag prod : Bool,
      description: "Running in production mode",
      default: DEFAULT_PROD,
      long: prod,
      required: true

    define_flag resources_path : String,
      description: "Resource directory",
      default: DEFAULT_RPATH,
      long: rpath,
      short: r,
      required: true

    define_flag output_path : String,
      description: "Output file",
      default: DEFAULT_OPATH,
      long: opath,
      short: o,
      required: true

    define_flag port : Int32,
      description: "Web server listening port",
      default: DEFAULT_PORT,
      long: port,
      short: p,
      required: true

    def run
      Config.init(flags)
    end
  end
end
