class ActionSheetController < UIViewController
  attr_reader :text_view
  attr_reader :buttons
  attr_reader :action_sheets

  def init
    super.tap do
      @text_view = build_text_view

      @buttons       = []
      @action_sheets = []

      [:automatic, :default, :black_translucent, :black_opaque].each do |style|
        @buttons       << build_button(style.to_s)
        @action_sheets << build_action_sheet(style)
      end
    end
  end

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.grayColor

    self.view.addSubview(self.text_view)

    self.buttons.each_with_index do |button, index|
      self.view.addSubview(button)

      button.when(UIControlEventTouchUpInside) { self.action_sheets[index].showInView(button) }
    end
  end

  def build_text_view
    text_view = UITextView.alloc.initWithFrame([[0, 0], [320, 194]])
    text_view.editable = false
    text_view.text     = "Waiting..."
    text_view
  end

  def build_button(title)
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle(title, forState:UIControlStateNormal)

    rect = self.buttons.empty? ? CGRectMake(20, 150, 280, 44) : self.buttons.last.frame
    button.frame = [[rect.origin.x, rect.origin.y + rect.size.height + 20], rect.size]

    button
  end

  def build_action_sheet(method)
    options = {
      :title        => method,
      :will_present => build_callback(:will_present, method),
      :did_present  => build_callback(:did_present, method),
      :on_click     => build_callback(:on_click, method),
      :will_dismiss => build_callback(:will_dismiss, method),
      :did_dismiss  => build_callback(:did_dismiss, method)
    }
    BW::UIActionSheet.send(method, options)
  end

  def build_callback(name, method)
    proc do |sheet, button|
      message = []
      message << "\n\n" + method.to_s if name == :will_present
      message << "\n" + name.to_s
      message << "\n" + button.inspect if button

      self.text_view.text += message.join
      self.text_view.selectedRange = NSMakeRange(self.text_view.text.length, 0)
    end
  end
end
