ImageResizeView = require '../lib/atom-image-resize-view'

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
        base64image = 'data:image/jpeg;base64,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'
        text = """
          abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
          #{base64image}
          abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
        """
        view = new ImageResizeView(editorId: @editorId)
        actual = view.findBase64EncodedImage text
        expect(actual).toContain "#{base64image}"
        expect(actual.length).toEqual 1

    describe "text contains base64 encoded png image", ->
      it "should be return array that has contans 1 String", ->
        base64image = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAA10lEQVR4nO3RsQ2AQAADsd9/MraCPg0VugJbygKXcwAAAAAAAAAAAAAA4Heuc+4/re79qg7kkFEHcsioAzlk1IEcMupADhl1IIeMOpBDRh3IIaMO5JBRB3LIqAM5ZNSBHDLqQA4ZdSCHjDqQQ0YdyCGjDuSQUQdyyKgDOWTUgRwy6kAOGXUgh4w6kENGHcghow7kkFEHcsioAzlk1IEcMupADhl1IIeMOpBDRh3IIaMO5JBRB3LIqAM5ZNSBHDLqQA4ZdSCHjDqQQwAAAAAAAAAAAAAA4GsPKBWqkXXeQC0AAAAASUVORK5CYII='
        text = """
          abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
          #{base64image}
          abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
        """
        view = new ImageResizeView(editorId: @editorId)
        actual = view.findBase64EncodedImage text
        expect(actual).toContain "#{base64image}"
        expect(actual.length).toEqual 1

    describe "text contains base64 non image string", ->
      it "should be return empty array", ->
        base64plain = 'data:text/plain;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAA10lEQVR4nO3RsQ2AQAADsd9/MraCPg0VugJbygKXcwAAAAAAAAAAAAAA4Heuc+4/re79qg7kkFEHcsioAzlk1IEcMupADhl1IIeMOpBDRh3IIaMO5JBRB3LIqAM5ZNSBHDLqQA4ZdSCHjDqQQ0YdyCGjDuSQUQdyyKgDOWTUgRwy6kAOGXUgh4w6kENGHcghow7kkFEHcsioAzlk1IEcMupADhl1IIeMOpBDRh3IIaMO5JBRB3LIqAM5ZNSBHDLqQA4ZdSCHjDqQQwAAAAAAAAAAAAAA4GsPKBWqkXXeQC0AAAAASUVORK5CYII='
        text = """
          abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
          #{base64plain}
          abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
        """
        view = new ImageResizeView(editorId: @editorId)
        actual = view.findBase64EncodedImage text
        expect(actual.length).toEqual 0

    describe "ImageResizeView#findBase64EncodedImage", ->
      describe "text contains base64 encoded jpeg and png image", ->
        it "should be return array that has contans 2 String", ->
          base64image1 = 'data:image/jpeg;base64,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'
          base64image2 = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAA10lEQVR4nO3RsQ2AQAADsd9/MraCPg0VugJbygKXcwAAAAAAAAAAAAAA4Heuc+4/re79qg7kkFEHcsioAzlk1IEcMupADhl1IIeMOpBDRh3IIaMO5JBRB3LIqAM5ZNSBHDLqQA4ZdSCHjDqQQ0YdyCGjDuSQUQdyyKgDOWTUgRwy6kAOGXUgh4w6kENGHcghow7kkFEHcsioAzlk1IEcMupADhl1IIeMOpBDRh3IIaMO5JBRB3LIqAM5ZNSBHDLqQA4ZdSCHjDqQQwAAAAAAAAAAAAAA4GsPKBWqkXXeQC0AAAAASUVORK5CYII='
          base64plain = 'data:text/plain;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAA10lEQVR4nO3RsQ2AQAADsd9/MraCPg0VugJbygKXcwAAAAAAAAAAAAAA4Heuc+4/re79qg7kkFEHcsioAzlk1IEcMupADhl1IIeMOpBDRh3IIaMO5JBRB3LIqAM5ZNSBHDLqQA4ZdSCHjDqQQ0YdyCGjDuSQUQdyyKgDOWTUgRwy6kAOGXUgh4w6kENGHcghow7kkFEHcsioAzlk1IEcMupADhl1IIeMOpBDRh3IIaMO5JBRB3LIqAM5ZNSBHDLqQA4ZdSCHjDqQQwAAAAAAAAAAAAAA4GsPKBWqkXXeQC0AAAAASUVORK5CYII='
          text = """
            abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
            #{base64image1}
            abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
            #{base64image2}
            abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz1234567890
            #{base64plain}
          """
          view = new ImageResizeView(editorId: @editorId)
          actual = view.findBase64EncodedImage text
          expect(actual).toContain "#{base64image1}"
          expect(actual).toContain "#{base64image2}"
          expect(actual).toNotContain "#{base64plain}"
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
