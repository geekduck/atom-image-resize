ImageResizeView = require '../lib/atom-image-resize-view'
fixtures = require './fixtures/base64images.coffee'

describe "ImageResizeView", ->
  describe "when atom open preview for text editor", ->
    beforeEach ->

    it "should be has editorId property", ->
      id = "12"
      view = new ImageResizeView(editorId: id)
      expect(view.editorId).toBe "#{id}"

  describe "ImageResizeView#findBase64EncodedImage", ->
    describe "text contains base64 encoded jpeg image", ->
      it "should be return array that has contans 1 String", ->
        text = """
          abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
          #{fixtures.base64jpeg}
          abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
        """
        view = new ImageResizeView(editorId: @editorId)
        actual = view.findBase64EncodedImage text
        expect(actual).toContain "#{fixtures.base64jpeg}"
        expect(actual.length).toEqual 1

    describe "text contains base64 encoded png image", ->
      it "should be return array that has contans 1 String", ->
        text = """
          abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
          #{fixtures.base64png}
          abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
        """
        view = new ImageResizeView(editorId: @editorId)
        actual = view.findBase64EncodedImage text
        expect(actual).toContain "#{fixtures.base64png}"
        expect(actual.length).toEqual 1

    describe "text contains base64 non image string", ->
      it "should be return empty array", ->
        text = """
          abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
          #{fixtures.base64plain}
          abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
        """
        view = new ImageResizeView(editorId: @editorId)
        actual = view.findBase64EncodedImage text
        expect(actual.length).toEqual 0

    describe "ImageResizeView#findBase64EncodedImage", ->
      describe "text contains base64 encoded jpeg and png image", ->
        it "should be return array that has contans 2 String", ->
          text = """
            abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
            #{fixtures.base64jpeg}
            abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
            #{fixtures.base64png}
            abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
            #{fixtures.base64plain}
          """
          view = new ImageResizeView(editorId: @editorId)
          actual = view.findBase64EncodedImage text
          expect(actual).toContain "#{fixtures.base64jpeg}"
          expect(actual).toContain "#{fixtures.base64png}"
          expect(actual).toNotContain "#{fixtures.base64plain}"
          expect(actual.length).toEqual 2

    describe "empty text", ->
      it "should be return empty array", ->
        text = ""
        view = new ImageResizeView(editorId: @editorId)
        actual = view.findBase64EncodedImage text
        expect(actual.length).toEqual 0

    describe "undefined", ->
      it "should be return empty array", ->
        text = ""
        view = new ImageResizeView(editorId: @editorId)
        actual = view.findBase64EncodedImage text
        expect(actual.length).toEqual 0

    describe "null", ->
      it "should be return empty array", ->
        text = ""
        view = new ImageResizeView(editorId: @editorId)
        actual = view.findBase64EncodedImage text
        expect(actual.length).toEqual 0
