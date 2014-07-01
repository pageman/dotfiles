
shadow_directory Cookbook
=========================

This cookbook creates a "shadow directory", which
is a directory is actually linked to another directory.

This is different than a simple link because it intelligently handles
any existing files either in the "replace" or "with" directories.

Requirements
------------

Only tested on OS X, but I doubt there would be any serious issues on
other platforms.

Usage
-----

`shadow_directory` is intended to be used within another cookbook. Use
it like so:

```
shadow_directory "Downloads -> Inbox" do
  replace File.expand_path("~/Downloads")
  with    File.expand_path("~/Inbox")
end
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Joel McCracken

MIT
