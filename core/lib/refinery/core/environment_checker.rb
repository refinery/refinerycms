# Check that Rails application configuration is consistent with what we expect.
require 'pathname'

module Refinery
  module Core
    class EnvironmentChecker

      def initialize(root_path, environments: %w(development test production))
        @root_path = Pathname.new(root_path)
        @environments = environments
      end

      def call
        environment_files.each do |env_file|
          # Refinery does not necessarily expect action_mailer to be available as
          # we may not always require it (currently only the authentication extension).
          # Rails, however, will optimistically place config entries for action_mailer.
          current_mailer_config = mailer_config(env_file)

          if current_mailer_config.present?
            new_mailer_config = [
              "  if config.respond_to?(:action_mailer)",
              current_mailer_config.gsub(%r{\A\n+?}, ''). # remove extraneous newlines at the start
                                    gsub(%r{^\ \ }) { |line| "  #{line}" }, # add indentation on each line
              "  end"
            ].join("\n")

            env_file.write(
              env_file.read.gsub(current_mailer_config, new_mailer_config)
            )
          end
        end
      end

      private
      attr_reader :environments, :root_path

      def environment_files
        environments.map { |env| root_path.join("config", "environments", "#{env}.rb") }
                    .select(&:file?)
      end

      def mailer_config(environment_file)
        root_path.join(environment_file).read.match(
          %r{^\s.+?config\.action_mailer\..+([\w\W]*\})?}
        ).to_a.flatten.first
      end
    end
  end
end
