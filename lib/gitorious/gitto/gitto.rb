module Gitorious
  module Gitto
    
    class BadShaError < StandardError; end # :nodoc:
    
    # The point of this class is primary to prevent dangerous/malicious arguments 
    # to be passed down to the underlying Git library, since it shells out to 
    # the git binary. 
    class Gitto
      def initialize(repository_path)
        @repository_path = repository_path
        @git = Git.bare(@repository_path)
      end
      attr_reader :repository_path, :git
      
      def log(num, skip=nil)
        @git.log(num, skip)
      end
      
      def tree(sha)
        check_sha(sha)
        @git.gtree(sha)
      end
      
      def commit(sha)
        check_sha(sha)
        @git.gcommit(sha)
      end
      
      def diff(old_sha, new_sha)
        check_sha(old_sha)
        check_sha(new_sha)
        @git.diff(old_sha, new_sha)
      end
      
      def blob(sha)
        check_sha(sha)
        @git.gblob(sha)
      end
      
      def branches
        @git.branches
      end  
      
      def tags
        @git.tags
      end    
      
      def remotes
        @git.remotes
      end
      
      def check_sha(objectish)
        if /^[a-z0-9~\{\}\^\.]*$/i !~ objectish.to_s
          raise BadShaError
        end
      end
      
    end
    
  end
end