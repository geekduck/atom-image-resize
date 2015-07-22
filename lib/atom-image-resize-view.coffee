path = require 'path'
{Emitter, Disposable, CompositeDisposable} = require 'atom'
{$, $$$, View} = require 'space-pen'
_ = require 'underscore-plus'
fs = require 'fs-plus'

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
            @option value: "pixel", "pixel"
            @option value: "percent", "percent"
        @div class: "block", =>
          @label class: "inline-block", for: "resize-destination", "Destination type:"
          @select outlet: "selectExtension", id: "resize-destination", class: 'inline-block resize-destination', =>
            @option value: "png", "png"
            @option value: "jpeg", "jpeg"
        @div class: "block", =>
          @label class: "inline-block", for: "resize-proportionally", class: 'setting-title', " Resize proportionally:"
          @input outlet: "inputProportionally", id: "resize-proportionally", class: 'inline-block resize-proportionally', type: 'checkbox', checked: "checked"

        @button class: 'btn fa fa-expand', click: 'resize', " resize"
        @button class: 'btn btn-default fa fa-file-o', click: 'saveAs', " Save As ..."
        @button class: 'btn btn-default fa fa-clipboard', click: 'clippy', " Copy Clipboard"

  decimalPoint: 2

  constructor: ({@uri, @filePath}) ->
    super
    @uri = @uri.replace(/^data:image\/jpg/, "data:image/jpeg") if @uri?
    @image = new Image
    @image.onload = =>
      @loadImage @image
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
    @inputWidth.val image.width
    @inputHeight.val image.height
    @selectExtension.val @getExtension()

  getExtension: ->
    extension
    if @filePath?
      extension = @filePath.slice(@filePath.lastIndexOf('.')).substring(1).replace("jpg", "jpeg")
    if @uri?
      extension = RegExp.$1 if @uri.match(/^data:image\/(png|jpeg|gif)/)?
      extension = "png" if extension == "gif"
    console.log extension
    extension

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

module.exports =
  class ImageResizeView extends View
    @content: ->
      @div class: 'atom-image-resize-container native-key-bindings', tabindex: -1, =>
        @div outlet: "imageContainer"

    protocol: 'atom-image-resize:'

    constructor: ({@editorId, @filePath}) ->
      super
      @emitter = new Emitter
      @disposables = new CompositeDisposable
      @loaded = false

    attached: ->
      return if @isAttached
      @isAttached = true

      if @editorId?
        @resolveEditor(@editorId)
      else
        if atom.workspace?
          @subscribeToFilePath(@filePath)
        else
          @disposables.add atom.packages.onDidActivateInitialPackages =>
            @subscribeToFilePath(@filePath)

    #serialize: ->
    #  deserializer: 'ImageResizeView'
    #  filePath: @getPath()
    #  editorId: @editorId

    destroy: ->
      @disposables.dispose()

    onDidChangeTitle: (callback) ->
      console.log 'onDidChangeTitle'
      @emitter.on 'did-change-title', callback

    onDidChangeModified: (callback) ->
      console.log 'onDidChangeModified'
      # No op to suppress deprecation warning
      new Disposable

    onDidChangeMarkdown: (callback) ->
      console.log 'onDidChangeModified'
      @emitter.on 'did-change-markdown', callback

    subscribeToFilePath: (filePath) ->
      @addResizableImageView filePath: filePath

    resolveEditor: (editorId) ->
      resolve = =>
        @editor = @editorForId(editorId)
        if @editor?
          @emitter.emit 'did-change-title' if @editor?
          @addResizableImageViews()
        else
          # The editor this preview was created for has been closed so close
          # this preview since a preview cannot be rendered without an editor
          atom.workspace?.paneForItem(this)?.destroyItem(this)

      if atom.workspace?
        resolve()
      else
        @disposables.add atom.packages.onDidActivateInitialPackages(resolve)

    addResizableImageViews: () ->
      words = @editor.getText().split(/\s+/)
      words.forEach (base64string, key) =>
        console.log base64string
        @addResizableImageView uri: base64string if base64string.length > 8

    addResizableImageView: ({uri, filePath}) ->
      if uri?
        @imageContainer.append new ResizableImageView uri: uri
      if filePath?
        @imageContainer.append new ResizableImageView filePath: filePath

    editorForId: (editorId) ->
      for editor in atom.workspace.getTextEditors()
        return editor if editor.id?.toString() is editorId.toString()
      null

    getTitle: ->
      if @file?
        "#{path.basename(@getPath())} Image Resize View"
      else if @editor?
        "#{@editor.getTitle()} Image Resize View"
      else
        "Image Resize View"

    getIconName: ->
      "ImageResizeView"

    getURI: ->
      if @file?
        "#{@protocol}//#{@getPath()}"
      else
        "#{@protocol}//editor/#{@editorId}"

    getPath: ->
      if @file?
        @file.getPath()
      else if @editor?
        @editor.getPath()

    showError: (result) ->
      failureMessage = result?.message

      @html $$$ ->
        @h2 'Previewing Image Failed'
        @h3 failureMessage if failureMessage?

    showLoading: ->
      @loading = true
      @html $$$ ->
        @div class: 'markdown-spinner', 'Loading Markdown\u2026'
