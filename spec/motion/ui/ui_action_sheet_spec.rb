shared "an instance with no options" do
  it "has the correct class" do
    @subject.class.should.equal(BW::UIActionSheet)
  end

  it "has the correct superclass" do
    @subject.superclass.should.equal(::UIActionSheet)
  end

  it "has no title" do
    @subject.title.should.be.nil
  end

  it "has the correct delegate" do
    @subject.delegate.should.equal(@subject)
  end

  it "has no will_present handler" do
    @subject.will_present.should.be.nil
  end

  it "has no did_present handler" do
    @subject.did_present.should.be.nil
  end

  it "has no on_system_cancel handler" do
    @subject.on_system_cancel.should.be.nil
  end

  it "has no will_dismiss handler" do
    @subject.will_dismiss.should.be.nil
  end

  it "has no did_dismiss handler" do
    @subject.did_dismiss.should.be.nil
  end
end

###################################################################################################

shared "an instance with a full set of options" do
  it "has the correct title" do
    @subject.title.should.equal(@options[:title])
  end

  it "has the correct delegate" do
    @subject.delegate.should.equal(@subject)
  end

  it "has the correct cancel button index" do
    @subject.cancel_button_index.should.equal(@options[:cancel_button_index])
  end

  it "has the correct buttons" do
    @subject.numberOfButtons.should.equal(1)
    @subject.buttonTitleAtIndex(0).should.equal(@options[:buttons])
  end

  it "has no will_present handler" do
    @subject.will_present.should.equal(@options[:will_present])
  end

  it "has no did_present handler" do
    @subject.did_present.should.equal(@options[:did_present])
  end

  it "has no on_system_cancel handler" do
    @subject.on_system_cancel.should.equal(@options[:on_system_cancel])
  end

  it "has the correct on_click handler" do
    @subject.on_click.should.equal(@options[:on_click])
  end

  it "has no will_dismiss handler" do
    @subject.will_dismiss.should.equal(@options[:will_dismiss])
  end

  it "has no did_dismiss handler" do
    @subject.did_dismiss.should.equal(@options[:did_dismiss])
  end
end

###################################################################################################

describe BW::UIActionSheet do
  describe ".new" do
    describe "given no options" do
      before do
        @subject = BW::UIActionSheet.new
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIActionSheetStyleAutomatic)
      end

      it "has no buttons" do
        @subject.numberOfButtons.should.equal(0)
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end

      it "has no on_click handler" do
        @subject.on_click.should.be.nil
      end
    end

    ###############################################################################################

    describe "given no options with a block" do
      before do
        @options = {}
        @block   = -> { true }
        @subject = BW::UIActionSheet.new(@options, &@block)
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIActionSheetStyleAutomatic)
      end

      it "has no buttons" do
        @subject.numberOfButtons.should.equal(0)
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@block)
      end
    end

    ###############################################################################################

    describe "given a full set of options" do
      before do
        @options = {
          :title                      => "title",
          :style                      => :default,
          :buttons                    => "button title",
          :cancel_button_index        => 0,
          :will_present               => -> { true },
          :did_present                => -> { true },
          :on_system_cancel           => -> { true },
          :on_click                   => -> { true },
          :will_dismiss               => -> { true },
          :did_dismiss                => -> { true }
        }
        @subject = BW::UIActionSheet.new(@options)
      end

      behaves_like "an instance with a full set of options"

      it "has the correct style" do
        @subject.style.should.equal(UIActionSheetStyleDefault)
      end
    end

    ###############################################################################################

    describe "given options with multiple button titles" do
      before do
        @options = { buttons: ["first button", "second button"] }
        @subject = BW::UIActionSheet.new(@options)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal(@options[:buttons][0])
        @subject.buttonTitleAtIndex(1).should.equal(@options[:buttons][1])
      end
    end

    ###############################################################################################

    describe "given options with both an on_click handler and a block" do
      before do
        @options = { on_click: -> { true }}
        @block   = -> { true }
        @subject = BW::UIActionSheet.new(@options, &@block)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@options[:on_click])
      end
    end
  end

  #################################################################################################

  describe ".automatic" do
    describe "given no options" do
      before do
        @subject = BW::UIActionSheet.automatic
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIActionSheetStyleAutomatic)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(1)
        @subject.buttonTitleAtIndex(0).should.equal("OK")
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end

      it "has no on_click handler" do
        @subject.on_click.should.be.nil
      end
    end

    ###############################################################################################

    describe "given no options with a block" do
      before do
        @options = {}
        @block   = -> { true }
        @subject = BW::UIActionSheet.automatic(@options, &@block)
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIActionSheetStyleAutomatic)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(1)
        @subject.buttonTitleAtIndex(0).should.equal("OK")
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@block)
      end
    end

    ###############################################################################################

    describe "given a full set of options" do
      before do
        @options = {
          :title                      => "title",
          :style                      => :default,
          :buttons                    => "button title",
          :cancel_button_index        => 0,
          :will_present               => -> { true },
          :did_present                => -> { true },
          :on_system_cancel           => -> { true },
          :on_click                   => -> { true },
          :will_dismiss               => -> { true },
          :did_dismiss                => -> { true }
        }
        @subject = BW::UIActionSheet.automatic(@options)
      end

      behaves_like "an instance with a full set of options"

      it "has the correct style" do
        @subject.style.should.equal(UIActionSheetStyleAutomatic)
      end
    end

    ###############################################################################################

    describe "given options with multiple button titles" do
      before do
        @options = { buttons: ["first button", "second button"] }
        @subject = BW::UIActionSheet.automatic(@options)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal(@options[:buttons][0])
        @subject.buttonTitleAtIndex(1).should.equal(@options[:buttons][1])
      end
    end

    ###############################################################################################

    describe "given options with a cancel button index" do
      before do
        @options = { cancel_button_index: 0 }
        @subject = BW::UIActionSheet.automatic(@options)
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(0)
      end
    end

    ###############################################################################################

    describe "given options with both an on_click handler and a block" do
      before do
        @options = { on_click: -> { true }}
        @block   = -> { true }
        @subject = BW::UIActionSheet.automatic(@options, &@block)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@options[:on_click])
      end
    end
  end

  #################################################################################################

  describe ".default" do
    describe "given no options" do
      before do
        @subject = BW::UIActionSheet.default
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIActionSheetStyleDefault)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(1)
        @subject.buttonTitleAtIndex(0).should.equal("OK")
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end

      it "has no on_click handler" do
        @subject.on_click.should.be.nil
      end
    end

    ###############################################################################################

    describe "given no options with a block" do
      before do
        @options = {}
        @block   = -> { true }
        @subject = BW::UIActionSheet.default(@options, &@block)
      end

      behaves_like "an instance with no options"

      it "has the correct style" do
        @subject.style.should.equal(UIActionSheetStyleDefault)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(1)
        @subject.buttonTitleAtIndex(0).should.equal("OK")
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@block)
      end
    end

    ###############################################################################################

    describe "given a full set of options" do
      before do
        @options = {
          :title                      => "title",
          :style                      => :automatic,
          :buttons                    => "button title",
          :cancel_button_index        => 0,
          :will_present               => -> { true },
          :did_present                => -> { true },
          :on_system_cancel           => -> { true },
          :on_click                   => -> { true },
          :will_dismiss               => -> { true },
          :did_dismiss                => -> { true }
        }
        @subject = BW::UIActionSheet.default(@options)
      end

      behaves_like "an instance with a full set of options"

      it "has the correct style" do
        @subject.style.should.equal(UIActionSheetStyleDefault)
      end
    end

    ###############################################################################################

    describe "given options with multiple button titles" do
      before do
        @options = { buttons: ["first button", "second button"] }
        @subject = BW::UIActionSheet.default(@options)
      end

      it "has the correct buttons" do
        @subject.numberOfButtons.should.equal(2)
        @subject.buttonTitleAtIndex(0).should.equal(@options[:buttons][0])
        @subject.buttonTitleAtIndex(1).should.equal(@options[:buttons][1])
      end
    end

    ###############################################################################################

    describe "given options with a cancel button index" do
      before do
        @options = { cancel_button_index: 0 }
        @subject = BW::UIActionSheet.default(@options)
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(0)
      end
    end

    ###############################################################################################

    describe "given options with both an on_click handler and a block" do
      before do
        @options = { on_click: -> { true }}
        @block   = -> { true }
        @subject = BW::UIActionSheet.default(@options, &@block)
      end

      it "has the correct on_click handler" do
        @subject.on_click.should.equal(@options[:on_click])
      end
    end
  end

  #################################################################################################

  BW::UIActionSheet.callbacks.each do |callback|
    describe ".#{callback}" do
      before do
        @subject = BW::UIActionSheet.new
      end

      describe "given no block" do
        before do
          @return = @subject.send(callback)
        end

        it "returns no handler" do
          @return.should.be.nil
        end

        it "has no handler" do
          @subject.send(callback).should.be.nil
        end
      end

      ###############################################################################################

      describe "given a block" do
        before do
          @block  = -> { true }
          @return = @subject.send(callback, &@block)
        end

        it "returns the subject" do
          @return.should.equal(@subject)
        end

        it "has the correct handler" do
          @subject.send(callback).should.equal(@block)
        end
      end
    end
  end

  #################################################################################################

  describe "#style=" do
    before do
      @subject = BW::UIActionSheet.new
    end

    describe "given no style" do
      before do
        @subject.style = nil
      end

      it "has the correct style" do
        @subject.style.should.equal(UIActionSheetStyleAutomatic)
      end
    end

    ###############################################################################################

    describe "given a style" do
      before do
        @subject.style = :default
      end

      it "has the correct style" do
        @subject.style.should.equal(UIActionSheetStyleDefault)
      end
    end
  end

  #################################################################################################

  describe "#cancel_button_index=" do
    before do
      @subject = BW::UIActionSheet.new
    end

    describe "given no cancel button index" do
      before do
        @subject.cancel_button_index = nil
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(-1)
      end
    end

    ###############################################################################################

    describe "given a cancel button index" do
      before do
        @subject.cancel_button_index = 0
      end

      it "has the correct cancel button index" do
        @subject.cancel_button_index.should.equal(0)
      end
    end
  end

  #################################################################################################

  describe "-willPresentActionSheet:" do
    before do
      @subject = BW::UIActionSheet.new
    end

    describe "given no will_present handler" do
      it "returns noting" do
        @subject.willPresentActionSheet(@subject).should.be.nil
      end
    end

    ###############################################################################################

    describe "given a will_present handler" do
      before do
        @subject.will_present do |sheet|
          sheet.should.equal(@subject)
          :will_present
        end
      end

      it "returns correctly" do
        @subject.willPresentActionSheet(@subject).should.equal(:will_present)
      end
    end
  end

  #################################################################################################

  describe "-didPresentActionSheet:" do
    before do
      @subject = BW::UIActionSheet.new
    end

    describe "given no did_present handler" do
      it "returns noting" do
        @subject.didPresentActionSheet(@subject).should.be.nil
      end
    end

    ###############################################################################################

    describe "given a did_present handler" do
      before do
        @subject.did_present do |sheet|
          sheet.should.equal(@subject)
          :did_present
        end
      end

      it "returns correctly" do
        @subject.didPresentActionSheet(@subject).should.equal(:did_present)
      end
    end
  end

  #################################################################################################

  describe "-actionSheetCancel:" do
    before do
      @subject = BW::UIActionSheet.new
    end

    describe "given no on_system_cancel handler" do
      it "returns noting" do
        @subject.actionSheetCancel(@subject).should.be.nil
      end
    end

    ###############################################################################################

    describe "given an on_system_cancel handler" do
      before do
        @subject.on_system_cancel do |sheet|
          sheet.should.equal(@subject)
          :on_system_cancel
        end
      end

      it "returns correctly" do
        @subject.actionSheetCancel(@subject).should.equal(:on_system_cancel)
      end
    end
  end

  #################################################################################################

  describe "-actionSheet:clickedButtonAtIndex:" do
    before do
      @index   = 0
      @button  = "button title"
      @subject = BW::UIActionSheet.new(buttons: @button)
    end

    describe "given no on_click handler" do
      it "returns noting" do
        @subject.actionSheet(@subject, clickedButtonAtIndex:@index).should.be.nil
      end
    end

    ###############################################################################################

    describe "given an on_click handler" do
      before do
        @subject.on_click do |sheet, button|
          sheet.should.equal(@subject)
          button.should.not.be.nil
          button.index.should.equal(@index)
          button.title.should.equal(@button)
          button.should.not.be.cancel
          :on_click
        end
      end

      it "returns correctly" do
        @subject.actionSheet(@subject, clickedButtonAtIndex:@index).should.equal(:on_click)
      end
    end

    ###############################################################################################

    describe "given an on_click handler with a cancel button index" do
      before do
        @subject.cancel_button_index = @index

        @subject.on_click do |sheet, button|
          sheet.should.equal(@subject)
          button.should.not.be.nil
          button.index.should.equal(@index)
          button.title.should.equal(@button)
          button.should.be.cancel
          :on_click
        end
      end

      it "returns correctly" do
        @subject.actionSheet(@subject, clickedButtonAtIndex:@index).should.equal(:on_click)
      end
    end
  end

  #################################################################################################

  describe "-actionSheet:willDismissWithButtonIndex:" do
    before do
      @index   = 0
      @button  = "button title"
      @subject = BW::UIActionSheet.new(buttons: @button)
    end

    describe "given no will_dismiss handler" do
      it "returns noting" do
        @subject.actionSheet(@subject, willDismissWithButtonIndex:@index).should.be.nil
      end
    end

    ###############################################################################################

    describe "given a will_dismiss handler" do
      before do
        @subject.will_dismiss do |sheet, button|
          sheet.should.equal(@subject)
          button.should.not.be.nil
          button.index.should.equal(@index)
          button.title.should.equal(@button)
          button.should.not.be.cancel
          :will_dismiss
        end
      end

      it "returns correctly" do
        @subject.actionSheet(@subject, willDismissWithButtonIndex:@index).should.equal(:will_dismiss)
      end
    end

    ###############################################################################################

    describe "given a will_dismiss handler with a cancel button index" do
      before do
        @subject.cancel_button_index = @index

        @subject.will_dismiss do |sheet, button|
          sheet.should.equal(@subject)
          button.should.not.be.nil
          button.index.should.equal(@index)
          button.title.should.equal(@button)
          button.should.be.cancel
          :will_dismiss
        end
      end

      it "returns correctly" do
        @subject.actionSheet(@subject, willDismissWithButtonIndex:@index).should.equal(:will_dismiss)
      end
    end
  end

  #################################################################################################

  describe "-actionSheet:didDismissWithButtonIndex:" do
    before do
      @index   = 0
      @button  = "button title"
      @subject = BW::UIActionSheet.new(buttons: @button)
    end

    describe "given no did_dismiss handler" do
      it "returns noting" do
        @subject.actionSheet(@subject, didDismissWithButtonIndex:@index).should.be.nil
      end
    end

    ###############################################################################################

    describe "given a did_dismiss handler" do
      before do
        @subject.did_dismiss do |sheet, button|
          sheet.should.equal(@subject)
          button.should.not.be.nil
          button.index.should.equal(@index)
          button.title.should.equal(@button)
          button.should.not.be.cancel
          :did_dismiss
        end
      end

      it "returns correctly" do
        @subject.actionSheet(@subject, didDismissWithButtonIndex:@index).should.equal(:did_dismiss)
      end
    end

    ###############################################################################################

    describe "given a did_dismiss handler with a cancel button index" do
      before do
        @subject.cancel_button_index = @index

        @subject.did_dismiss do |sheet, button|
          sheet.should.equal(@subject)
          button.should.not.be.nil
          button.index.should.equal(@index)
          button.title.should.equal(@button)
          button.should.be.cancel
          :did_dismiss
        end
      end

      it "returns correctly" do
        @subject.actionSheet(@subject, didDismissWithButtonIndex:@index).should.equal(:did_dismiss)
      end
    end
  end
end
