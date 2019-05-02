require "kemal"

module ZhenXiang::Web
  def self.start(tpls)
    config = CLI::Config.instance
    serve_static({"gzip" => false})
    public_folder "public"

    get "/" do
      render "src/views/index.html.ecr"
    end

    get "/:name" do |env|
      name = env.params.url["name"]
      if (result = tpls.select { |tpl| tpl.path == name }) && result.size == 1 && (tpl = result[0])
        tpl.name
      else
        halt env, status_code: 404, response: "Not Found"
      end
    end

    Kemal.config.env = "production" if config.prod
    Kemal.run(args: nil, port: config.port)
  end
end
