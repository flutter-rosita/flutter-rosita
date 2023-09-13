## 0.3.2

- Add support rendering Slider widget
- Add RositaImageFilter.blur()
- Implement method drawLine to RositaCanvas
- Implement clip rect
- Fix drawRositaParagraph font style for EditableText
- Fix RositaSvgPicture layout size
- Remove variable rositaTimeStamp

## 0.3.1

- Fix paint paragraph font style
- Initial support shader gradient
- Fix focus loosed on routes
- Fix used constant rositaEnableRoutesChanged where needed

## 0.3.0

- Add support RawImage
- Add optimization constant rositaDisableRoutesChanged (ROSITA_DISABLE_ROUTES_CHANGED)
- Add optimization constant rositaEnableVisitChildren (ROSITA_ENABLE_VISIT_CHILDREN)
- Add method RositaSemantics as constructor to disable Semantics widget
- Disable calls updateCompositingBits, add constant rositaDisableUpdateCompositingBits (ROSITA_DISABLE_UPDATE_COMPOSITING_BITS)
  - skip call flushCompositingBits and markNeedsCompositingBitsUpdate
  - skip build RepaintBoundary widget
- Disable markNeedsPaint calls on layout
- Remove rositaSkipSlowFrames constant

## 0.2.0

- Add widget RositaColorRBox
- Fixed the order of rendering HTML elements
- Optimize RenderObject.getTransformTo
    - skip transform when non changed
    - remove RositaRectMixin
- Optimize html style getter call

## 0.1.0

- Fix text lineHeight when fontBoundingBoxAscent is nul
- Fix for browsers (Chrome 53) where shadowRoot not supported
- Fix for browsers where hex color with alpha not supported
- Rename color extension method toHexString() to toStyleString()

## 0.0.7

- Fix never call rosita flush callbacks after skip low frames
- Fix show render object when it detach and attache after
- Fix scroll sliver offset
- Optimize text
- Optimize DOM tree
- Add support render transform
- Add support BoxDecoration.border
- Add support BoxDecoration.position
- Add support RenderPhysicalShape.clipper
- Fix input text field with text align is center

## 0.0.6

- Refactor docs
- Add optimize to disable semantics call
- Optimize call RRect.isEllipse for JS
- Optimize time call draw frame with skip slow frame
- Fix canvas clear rect
- Initial support render clip
- Add support image asset

## 0.0.5

Refactor widget RositaImage

- add constructors: RositaImage.asset(), const RositaImage.network()
- delete constructor RositaImage()
- add support: alignment, fit

Add widget RositaSvgPicture

Optimize find focus with focus traversal group

- add RositaRectMixin

Optimize render with hidden skip count RenderTheater children

- Add RositaRenderTheaterMixin

Optimize usage html canvas 2d

Optimize call _scheduleMouseTrackerUpdate

- call after scroll
- call on mouse event

Fix decoration when color is null

## 0.0.4

Canvas paint features

- fix method drawRRect radius
- add method drawCircle
- Fix HTML padding position

Refactor text style apply to HtmlElement

- Add RositaTextUtils
- refactor RositaRenderParagraphMixin

Fix render

- Call methods rositaLayout and rositaPaint for RenderBox when hasSize
- Add RositaRadiusUtils

Disable method flutter paint

Refactor apply html opacity style

- Add class RositaOpacityUtils

Optimize render paragraph

- add widget RositaText, RositaRichText
- add render box RositaRenderParagraph
- add class RositaParagraphUtils
- fix font style

Refactor RositaImage

## 0.0.3

* Fix build error with IO, change dart:html dependency

## 0.0.2

* Fix RositaRenderBox

## 0.0.1

* Initial version
