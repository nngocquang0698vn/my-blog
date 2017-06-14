task :stop do
  on  roles(:app) do
    within(release_path) do
      execute "rm -rf #{fetch:deploy_to}"
    end
  end
end
