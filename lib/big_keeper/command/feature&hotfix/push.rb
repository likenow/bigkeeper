require 'big_keeper/util/logger'
require 'big_keeper/util/cache_operator'

require 'big_keeper/dependency/dep_service'

module BigKeeper

  def self.push(path, user, comment, type)
    begin
      # Parse Bigkeeper file
      BigkeeperParser.parse("#{path}/Bigkeeper")
      branch_name = GitOperator.new.current_branch(path)

      Logger.error("Not a #{GitflowType.name(type)} branch, exit.") unless branch_name.include? GitflowType.name(type)

      modules = ModuleCacheOperator.new(path).current_path_modules

      modules.each do |module_name|
        ModuleService.new.push(path, user, module_name, branch_name, type, comment)
      end

      Logger.highlight("Push branch '#{branch_name}' for 'Home'...")
      GitService.new.verify_push(path, comment, branch_name, 'Home')
    ensure
    end
  end
end
