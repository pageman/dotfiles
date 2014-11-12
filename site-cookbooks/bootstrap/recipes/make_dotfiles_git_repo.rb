
# assume we now have git
# adapted from
# http://stackoverflow.com/questions/2411031/how-do-i-clone-into-a-non-empty-directory

dotfiles = ::File.expand_path("~/dotfiles/")
dotfiles_git = ::File.join(dotfiles, ".git")
bash "make the dotfiles directory become a git repository" do
  cwd dotfiles
  user node[:current_user]
  not_if { ::Dir.exist? dotfiles_git }
  code <<-EOC
    git clone --no-checkout https://github.com/joelmccracken/dotfiles.git dotfiles-tmp
    mv dotfiles-tmp/.git #{dotfiles_git}
    rmdir dotfiles-tmp
    cd #{dotfiles_git}/..
    git reset --hard HEAD
  EOC
end
