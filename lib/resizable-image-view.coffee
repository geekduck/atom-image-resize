{$, View} = require 'space-pen'

module.exports =
  class ResizableImageView extends View
    @content: ->
      @div class: 'atom-image-resize native-key-bindings', tabindex: -1, =>
        @canvas outlet: "canvas"
        @div =>
          @div class: "block", =>
            @label class: "inline-block", for: "resize-width", "Width:"
            @input outlet: "inputWidth", id: "resize-width" , class: 'inline-block resize-width', type: 'text'
          @div class: "block", =>
            @label class: "inline-block", for: "resize-height", "Height:"
            @input outlet: "inputHeight", id: "resize-height", class: 'inline-block resize-height', type: 'text'
          @div class: "block", =>
            @label class: "inline-block", for: "resize-base", "Unit:"
            @select outlet: "selectImageUnit", id: "resize-image-unit", class: 'inline-block resize-image-unit', =>
              @option value: "pixel", selected: "selected", "pixel"
              @option value: "percent", "percent"
          @div class: "block", =>
            @label class: "inline-block", for: "resize-destination", "Destination type:"
            @select outlet: "selectExtension", id: "resize-destination", class: 'inline-block resize-destination', =>
              @option value: "png", selected: "selected", "png"
              @option value: "jpeg", "jpeg"
          @div class: "block", =>
            @label class: "inline-block", for: "resize-proportionally", class: 'setting-title', " Resize proportionally:"
            @input outlet: "inputProportionally", id: "resize-proportionally", class: 'inline-block resize-proportionally', type: 'checkbox', checked: "checked"

          @button class: 'btn fa fa-expand', click: 'resize', " resize"
          @button class: 'btn btn-default fa fa-file-o', click: 'saveAs', " Save As ..."
          @button class: 'btn btn-default fa fa-clipboard', click: 'clippy', " Copy Clipboard"

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

      if event.target.id is @inputWidth[0].id
        width = Number $(event.target).val()
        unless isNaN width
          ratio = width / @originalImage.width
          @inputHeight.val (Math.round @originalImage.height * ratio)
      else if event.target.id is @inputHeight[0].id
        height = Number $(event.target).val()
        unless isNaN height
          ratio = height / @originalImage.height
          @inputWidth.val (Math.round @originalImage.width * ratio)


    changeImageUnit: (event)->
      if @selectImageUnit.val() == "pixel"
        @convertPercentToPixel(event)
      else if @selectImageUnit.val() == "percent"
        @convertPixelToPercent(event)

    convertPixelToPercent: ->
      console.log "convertPixelToPercent"

    convertPercentToPixel: ->
      console.log "convertPercentToPixel"

    loadImage: (image)->
      ctx = @canvas[0].getContext '2d'
      @canvas.attr
        width: image.width
        height: image.height
      ctx.drawImage image, 0, 0
      @originalImage = image
      @getExtension()
      @inputWidth.val image.width
      @inputHeight.val image.height
      @selectExtension.val @extension

    getExtension: ->
      if @filePath?
        @extension = @filePath.slice(@filePath.lastIndexOf('.')).substring(1).replace("jpg", "jpeg")
      if @uri?
        @extension = RegExp.$1 if @uri.match(/^data:image\/(png|jpeg|gif)/)?
      @extension = "png" if @extension == "gif" # canvas.toDataURL can set 'jpeg' and 'png' but 'gif'

    saveAs: ->
      return if @loading
      console.log "saveAs"

    resize: ->
      dstWidth = @inputWidth.val()
      dstHeigth = @inputHeight.val()
      resizeCanvas = document.createElement "canvas"
      resizeCanvas.setAttribute 'width', dstWidth
      resizeCanvas.setAttribute 'height', dstHeigth
      resizeCtx = resizeCanvas.getContext '2d'
      resizeCtx.drawImage @originalImage, 0, 0, @originalImage.width, @originalImage.height, 0, 0, dstWidth, dstHeigth
      ctx = @canvas[0].getContext '2d'
      @canvas.attr
        width: dstWidth
        height: dstHeigth
      ctx.drawImage resizeCanvas, 0, 0

    clippy: ->
      atom.clipboard.write @canvas[0].toDataURL("image/" + @selectExtension.val())