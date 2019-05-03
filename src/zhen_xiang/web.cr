require "kemal"

module ZhenXiang::Web
  def self.start(tpls)
    config = CLI::Config.instance
    serve_static({"gzip" => false})
    public_folder "public"

    get "/" do
      cur = find_template(tpls, "zhenxiang") || tpls[0]
      render "src/views/index.html.ecr", "src/views/layout.html.ecr"
    end

    get "/:name" do |env|
      name = env.params.url["name"]
      if cur = find_template tpls, name
        render "src/views/index.html.ecr", "src/views/layout.html.ecr"
      else
        halt env, status_code: 404, response: "Not Found"
      end
    end

    get "/template/video/:path" do |env|
      path = env.params.url["path"]
      if cur = find_template tpls, path
        send_file env, cur.video
      else
        halt env, status_code: 404, response: "Not Found"
      end
    end

    post "/:template/make" do |env|
      template = env.params.url["template"]
      subtitles = env.params.json["subtitles"].as(Array)

      if cur = find_template tpls, template
        cur.output(subtitles, :mp4, config.opath)
        cur.output(subtitles, :gif, config.opath)
      else
        halt env, status_code: 404, response: "Not Found"
      end
    end

    get "/download/:filename" do |env|
      filename = env.params.url["filename"]
      send_file env, "#{config.opath}/#{filename}"
    end

    Kemal.config.env = "production" if config.prod
    Kemal.run(args: nil, port: config.port)
  end

  def self.find_template(tpls, name)
    if (result = tpls.select { |tpl| tpl.path == name }) && result.size == 1 && (tpl = result[0])
      tpl
    end
  end
end
