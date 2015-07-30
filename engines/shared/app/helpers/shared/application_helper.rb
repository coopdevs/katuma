module Shared
  module ApplicationHelper
    # default types: success, error, notice
    def show_flash(*arguments)
      messages = [:success, :error, :notice] + arguments
      flash.select do |key, value|
        messages.include? key
      end.each do |type, message|
        @is_error = (type === :error)
        unless message.blank?
          haml_tag :div, class: "alert alert-#{type}" do
            haml_tag :button, type: 'button', class: 'close', data: {dismiss: 'alert'}, 'aria-label' => 'Close' do
              haml_tag :span, '&times;', aria: {hidden: true}
            end
             html_concat sanitize(messages)
          end
        end
      end
    end
  end
end
