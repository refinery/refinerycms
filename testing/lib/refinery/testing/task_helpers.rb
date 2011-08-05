module Refinery
  module Testing
    module TaskHelpers
      DUMMY_APP_GIT_URL = "git://github.com/enmasse-entertainment/refinerycms-engine-dummy.git"
      
      def submodule_exists?(path)
        module_file = File.join(ENGINE_PATH, ".gitmodules")
        return false unless File.exists?(module_file)
        
        File.read(module_file).include?("[submodule \"#{path}\"]")
      end
    end
  end
end
