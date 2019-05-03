require "kemal"

module ZhenXiang::Web
  def self.start(tpls)
    config = CLI::Config.instance
    serve_static({"gzip" => false})
    public_folder "public"

    get "/" do
      cur = tpls[0]
      render "src/views/index.html.ecr", "src/views/layout.html.ecr"
    end

    get "/:name" do |env|
      name = env.params.url["name"]
      if (result = tpls.select { |tpl| tpl.path == name }) && result.size == 1 && (tpl = result[0])
        cur = tpl
        render "src/views/index.html.ecr", "src/views/layout.html.ecr"
      else
        halt env, status_code: 404, response: "Not Found"
      end
    end

    get "/template/:path" do |env|
      path = env.params.url["path"]
      if (result = tpls.select { |tpl| tpl.path == path }) && result.size == 1 && (tpl = result[0])
        send_file env, tpl.video
      else
        halt env, status_code: 404, response: "Not Found"
      end
    end

    Kemal.config.env = "production" if config.prod
    Kemal.run(args: nil, port: config.port)
  end
end
