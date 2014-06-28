
current_dir = File.expand_path(File.dirname __FILE__)
file_cache_path current_dir
cookbook_path [File.join(current_dir, "cookbooks"),
               File.join(current_dir, "site-cookbooks")]
