path = require 'path'
{$, $$$, View, TextEditorView} = require 'atom-space-pen-views'
fs = require 'fs-plus'
_ = require 'underscore-plus'

module.exports =
  class ResizableImageView extends View
    @content: ->
      @div class: 'atom-image-resize', tabindex: -1, =>
        @div class: "canvas-container", =>
          @canvas outlet: "canvas"
        @div class: "settings-view atom-image-resize-settings", =>
          @div class: "control-group", =>
            @div class: "controls", =>
              @label class: "control-label", =>
                @div class: "setting-title", "Width"
                @div class: "setting-description"
              @div class: "controls", =>
                @subview "inputWidth", new TextEditorView mini: true, attributes: {id:"inputWidth"}
          @div class: "control-group", =>
            @div class: "controls", =>
              @label class: "control-label", =>
                @div class: "setting-title", "Height"
                @div class: "setting-description"
              @div class: "controls", =>
                @subview "inputHeight", new TextEditorView mini: true, attributes: {id:"inputHeight"}
          @div class: "control-group", =>
            @div class: "controls", =>
              @label class: "control-label", =>
                @div class: "setting-title", "Unit"
                @div class: "setting-description"
              @select outlet: "selectImageUnit", id: "resize-image-unit", class: 'form-control', =>
                @option value: "pixel", selected: "selected", "pixel"
                @option value: "percent", "percent"
          @div class: "control-group", =>
            @div class: "controls", =>
              @label class: "control-label", =>
                @div class: "setting-title", "Destination type"
                @div class: "setting-description"
              @select outlet: "selectExtension", id: "resize-destination", class: 'form-control', =>
                @option value: "png", selected: "selected", "png"
                @option value: "jpeg", "jpeg"
          @div class: "control-group", =>
            @div class: "controls", =>
              @div class: "checkbox", =>
                @label for: "resize-proportionally", =>
                  @input outlet: "inputProportionally", id: "resize-proportionally", type: 'checkbox', checked: "checked"
                  @div class: "setting-title", "Resize proportionally"
                @div class: "setting-description"
        @div class: "block", =>
          @button class: 'inline-block btn fa fa-expand', click: 'resize', " resize"
          @button class: 'inline-block btn fa fa-file-o', click: 'saveAs', " Save As ..."
          @button class: 'inline-block btn fa fa-clipboard', click: 'clippy', " Copy Clipboard"

    extension: "png"
    unit: "pixel"
    loaded: false

    initialize: ({@uri, @filePath}) ->
      @uri = @uri.replace(/^data:image\/jpg/, "data:image/jpeg") if @uri?
      @image = new Image
      @image.onload = =>
        @loadImage @image
        @loaded = true
      @resizeProportionally = true

      @eventHandler()

    attached: ->
      @image.src = @uri || @filePath

    eventHandler: ->
      @selectImageUnit.on 'change', (event)=>
        @changeImageUnit(event)
      @inputWidth.on 'keyup', (event)=>
        @changeRatio(event)
      @inputHeight.on 'keyup', (event)=>
        @changeRatio(event)
      @inputProportionally.on 'change', (event)=>
        @resizeProportionally = $(event.target).prop "checked"

    changeRatio: (event)->
      return unless @resizeProportionally

      unit = @selectImageUnit.val()
      if unit == "pixel"
        if event.target.id is @inputWidth[0].id
          width = Number @inputWidth.getText()
          console.log "width:#{width}"
          unless isNaN width
            ratio = width / @originalImage.width
            console.dir @inputHeight
            @inputHeight.setText (Math.round @originalImage.height * ratio) + ""
        else if event.target.id is @inputHeight[0].id
          height = Number @inputHeight.getText()
          console.log "height:#{height}"
          unless isNaN height
            ratio = height / @originalImage.height
            @inputWidth.setText (Math.round @originalImage.width * ratio) + ""
      else if unit == "percent"
        if event.target.id is @inputWidth[0].id
          width = Number @inputWidth.getText()
          unless isNaN width
            @inputHeight.setText width + ""
        else if event.target.id is @inputHeight[0].id
          height = Number @inputHeight.getText()
          unless isNaN height
            @inputWidth.setText height + ""

    changeImageUnit: (event)->
      unit = @selectImageUnit.val()
      if unit == "pixel"
        @convertPercentToPixel(event)
      else if unit == "percent"
        @convertPixelToPercent(event)

    convertPixelToPercent: ->
      @inputWidth.setText Math.round(100 * @inputWidth.getText() / @originalImage.width) + ""
      @inputHeight.setText Math.round(100 * @inputHeight.getText() / @originalImage.height) + ""


    convertPercentToPixel: ->
      @inputWidth.setText Math.round(@originalImage.width * @inputWidth.getText() / 100) + ""
      @inputHeight.setText Math.round(@originalImage.height * @inputHeight.getText() / 100) + ""

    loadImage: (image)->
      ctx = @canvas[0].getContext '2d'
      @canvas.attr
        width: image.width
        height: image.height
      ctx.drawImage image, 0, 0
      @originalImage = image
      @getExtension()
      @resizeWidth = image.width
      @resizeHeight = image.height
      @inputWidth.setText image.width + ""
      @inputHeight.setText image.height + ""
      @selectExtension.val @extension

    getExtension: ->
      if @filePath?
        @extension = @filePath.slice(@filePath.lastIndexOf('.')).substring(1).replace("jpg", "jpeg")
      if @uri?
        @extension = RegExp.$1 if @uri.match(/^data:image\/(png|jpeg|gif)/)?
      @extension = "png" if @extension == "gif" # canvas.toDataURL can set 'jpeg' and 'png' but 'gif'

    setInputWidth: (width)->
      return if _.isNaN Number width
      @inputWidth.setText width + ""

    setInputHeight: (height)->
      return if _.isNaN Number height
      @inputHeight.setText height + ""

    getInputWidth: ->
      Number @inputWidth.getText()

    getInputHeight: ->
      Number @inputHeight.getText()

    saveAs: ->
      filePath = @getPath()
      title = 'image'
      if filePath
        title = path.parse(filePath).name
        filePath += ".#{@selectExtension.val()}"
      else
        filePath = "image.#{@selectExtension.val()}"
        if projectPath = atom.project.getPaths()[0]
          filePath = path.join(projectPath, filePath)

      if imageFilePath = atom.showSaveDialogSync(filePath)
        binary = @getBinary()
        console.dir binary
        fs.writeFileSync(imageFilePath, binary)
        atom.workspace.open(imageFilePath)

    getBinary: ->
      new Buffer(@canvas[0].toDataURL("image/#{@selectExtension.val()}").split(',')[1], 'base64')

    getPath: ->
      if @file?
        @file.getPath()
      else if @editor?
        @editor.getPath()

    getResizeWidthHeight: ->
      unit = @selectImageUnit.val()
      if unit == "pixel"
        return {
          width: @inputWidth.getText()
          height: @inputHeight.getText()
        }
      else if unit == "percent"
        return {
          width: @originalImage.width * @inputWidth.getText() / 100
          height: @originalImage.height * @inputHeight.getText() / 100
        }

    resize: ->
      {width, height} = @getResizeWidthHeight()
      resizeCanvas = document.createElement "canvas"
      resizeCanvas.setAttribute 'width', width
      resizeCanvas.setAttribute 'height', height
      resizeCtx = resizeCanvas.getContext '2d'
      resizeCtx.drawImage @originalImage, 0, 0, @originalImage.width, @originalImage.height, 0, 0, width, height
      ctx = @canvas[0].getContext '2d'
      @canvas.attr
        width: width
        height: height
      ctx.drawImage resizeCanvas, 0, 0

    clippy: ->
      atom.clipboard.write @canvas[0].toDataURL("image/" + @selectExtension.val())