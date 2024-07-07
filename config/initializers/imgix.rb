Rails.application.configure do
  config.imgix = {
    source: "h1.imgix.net",
    use_https: true,
    include_library_param: true
  }
end