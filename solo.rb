
current_dir = File.expand_path(File.dirname __FILE__)
file_cache_path ::File.join(current_dir, "tmp", "cache")
cookbook_path [File.join(current_dir, "cookbooks"),
               File.join(current_dir, "site-cookbooks")]
data_bag_path ::File.join(current_dir, "data_bags")
