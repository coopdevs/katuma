module Shared
  module ApplicationHelper
    # default types: success, error, notice
    def show_flash(*arguments)
      messages = [:success, :error, :notice] + arguments
      flash.select do |key, value|
        messages.include? key.parameterize.underscore.to_sym
      end.each do |type, message|
        @is_error = (type === :error)
        type = type.parameterize.underscore.to_sym
        type = type === :error ? :danger : type
        unless message.blank?
          haml_tag :div, class: "alert alert-#{type}" do
            haml_tag :button, type: 'button', class: 'close', data: {dismiss: 'alert'}, 'aria-label' => 'Close' do
              haml_tag :span, aria: {hidden: true} do
                haml_concat '&times;'
              end
            end
            haml_concat sanitize(message)
          end
        end
      end
    end
  end
end
