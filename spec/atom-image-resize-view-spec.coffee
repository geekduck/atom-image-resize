ImageResizeView = require '../lib/atom-image-resize-view'

describe "ImageResizeView", ->
  describe "when atom open preview for text editor", ->
    beforeEach ->
      @editorId = "12"
    it "should be has editorId property", ->
      view = new ImageResizeView(editorId: @editorId)
      expect(view.editorId).toBe "#{@editorId}"
