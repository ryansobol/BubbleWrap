module BubbleWrap
  class UIActionSheet < ::UIActionSheet
    @callbacks = [
      :will_present,
      :did_present,
      :on_system_cancel,
      :on_click,
      :will_dismiss,
      :did_dismiss
    ]

    class << self
      attr_reader :callbacks

      def new(options = {}, &block)
        sheet = alloc.initWithTitle(options[:title],
          delegate: nil,
          cancelButtonTitle: nil,
          destructiveButtonTitle: nil,
          otherButtonTitles: nil
        )

        Array(options[:buttons]).each { |title| sheet.addButtonWithTitle(title) }

        sheet.style                    = options[:style]
        sheet.delegate                 = sheet
        sheet.cancel_button_index      = options[:cancel_button_index]
        sheet.destructive_button_index = options[:destructive_button_index]

        sheet.instance_variable_set(:@handlers, {})
        options[:on_click] ||= block

        callbacks.each do |callback|
          sheet.send(callback, &options[callback]) if options[callback]
        end

        sheet
      end
    end

    def style
      actionSheetStyle
    end

    def style=(value)
      self.actionSheetStyle = Constants.get("UIActionSheetStyle", value) if value
    end

    def cancel_button_index
      cancelButtonIndex
    end

    def cancel_button_index=(value)
      self.cancelButtonIndex = value if value
    end

    def destructive_button_index
      destructiveButtonIndex
    end

    def destructive_button_index=(value)
      self.destructiveButtonIndex = value if value
    end

    ###############################################################################################

    class Button
      def initialize(sheet, index)
        @index       = index
        @title       = sheet.buttonTitleAtIndex(index)
        @cancel      = sheet.cancelButtonIndex == index
        @destructive = sheet.destructiveButtonIndex == index
      end

      attr_reader :index, :title
      def cancel?; @cancel end
      def destructive?; @destructive end
    end

    ###############################################################################################

    attr_reader :handlers
    protected   :handlers

    callbacks.each do |callback|
      define_method(callback) do |&block|
        return handlers[callback] unless block

        handlers[callback] = block if block
        self
      end
    end

    # UIActionSheetDelegate protocol ################################################################

    def willPresentActionSheet(sheet)
      return unless handlers[:will_present]
      handlers[:will_present].call(sheet)
    end

    def didPresentActionSheet(sheet)
      return unless handlers[:did_present]
      handlers[:did_present].call(sheet)
    end

    def actionSheetCancel(sheet)
      return unless handlers[:on_system_cancel]
      handlers[:on_system_cancel].call(sheet)
    end

    def actionSheet(sheet, clickedButtonAtIndex:index)
      return unless handlers[:on_click]
      handlers[:on_click].call(sheet, Button.new(sheet, index))
    end

    def actionSheet(sheet, willDismissWithButtonIndex:index)
      return unless handlers[:will_dismiss]
      handlers[:will_dismiss].call(sheet, Button.new(sheet, index))
    end

    def actionSheet(sheet, didDismissWithButtonIndex:index)
      return unless handlers[:did_dismiss]
      handlers[:did_dismiss].call(sheet, Button.new(sheet, index))
    end
  end
end
