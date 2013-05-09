module BW
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

    attr_accessor :clicked_button
    protected     :clicked_button=

    class ClickedButton
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
      sheet.clicked_button = nil
      handlers[:will_present].call(sheet) if handlers[:will_present]
    end

    def didPresentActionSheet(sheet)
      sheet.clicked_button = nil
      handlers[:did_present].call(sheet) if handlers[:did_present]
    end

    def actionSheetCancel(sheet)
      sheet.clicked_button = nil
      handlers[:on_system_cancel].call(sheet) if handlers[:on_system_cancel]
    end

    def actionSheet(sheet, clickedButtonAtIndex:index)
      sheet.clicked_button = ClickedButton.new(sheet, index)
      handlers[:on_click].call(sheet) if handlers[:on_click]
    end

    def actionSheet(sheet, willDismissWithButtonIndex:index)
      sheet.clicked_button = ClickedButton.new(sheet, index)
      handlers[:will_dismiss].call(sheet) if handlers[:will_dismiss]
    end

    def actionSheet(sheet, didDismissWithButtonIndex:index)
      sheet.clicked_button = ClickedButton.new(sheet, index)
      handlers[:did_dismiss].call(sheet) if handlers[:did_dismiss]
    end
  end
end
