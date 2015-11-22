module RailsAdmin
  module Config
    module Actions
      class ToggleAccessLevel < RailsAdmin::Config::Actions::Base
        # This ensures the action only shows up for Users
        register_instance_option :visible? do
          authorized? && bindings[:object].class == User
        end
        # We want the action on members, not the Users collection
        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-certificate'
        end

        # You may or may not want pjax for your action
        register_instance_option :pjax? do
          false
        end

        register_instance_option :controller do
          Proc.new do
            begin
              if @object.read_only?
                @object.update!(access_level: 'write_only')
              elsif @object.write_only?
                @object.update!(access_level: 'read_only')
              end
              redirect_to back_or_index, flash: {success: "Successfully toggled access_level of #{@object.email}"}
            rescue => e
              redirect_to back_or_index, flash: {error: "Error"}
            end
          end
        end
      end
    end
  end
end