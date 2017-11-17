class YamlLoader
  def self.user_info(user_key)
    project_root = File.expand_path('../../../..', __FILE__)
    YAML.load_file("#{project_root}/config/accounts.yml")[user_key]
  end
end
