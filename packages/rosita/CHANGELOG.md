## 0.5.3

- Disable setState on end opacity transition to RositaFadeImage widget
- Fix RositaAnimatedOpacity

## 0.5.2

- Fix create Blob url
- Fix canvas paint with offset
- Add optimized AnimationBuilder
- Disable Semantics widget with RositaSemantics
- Optimization with rebuild only dirty elements
- Fix run debug mode with Rosita
- Optimization RositaCanvas painting
- Optimization rositaLayout

## 0.5.1

Version up to Flutter 3.22.2

## 0.5.0

Refactoring from package:universal_html to package:web

## 0.4.20

- Add support word-break

## 0.4.19

- Fix RositaFadeImage without placeholder
- Fix measure text for webOS with Chrome

## 0.4.18

- Add RositaFadeImage widget

## 0.4.17

Fix using rosita dependency

- move method applyCustomClipper from rosita package to flutter-rosita
- add support ShapeDecoration

## 0.4.16

- Fix initial position label in input text decoration
- Fix update cursor
- Add support clip shape CircleBorder
- Add support CustomClipper<Path>
- Fix clipped canvas paint after translate
- Fix repaint canvas on change devicePixelRatio
- Fix wrap text in Firefox

## 0.4.15

- Initial support RenderFittedBox
- Fix canvas drawDRRect with circle path
- Add support SingleChildScrollView
- Add support canvas drawRRect
- Add support canvas drawPath
- Fix _RenderDecorationLayout children order paint
- Fix paint EditableText on update text controller value
- Fix overlay SliverPersistentHeader in scroll
- Fix paint InkWell Egor
- Fix work HtmlElementView Egor
- Fix scroll clipping in scrollable_positioned_list
- Fix blurry painting in canvas
- Fix label offset in input decorator

## 0.4.14

- Fix color blend RositaSvgPicture to old Chrome Browser

## 0.4.13

- Add color blend to RositaSvgPicture

## 0.4.12

- Fix clipping RenderViewportBase when hasVisualOverflow is false
- Fix child offset in BoxDecoration with border style

## 0.4.11

- Initial support BoxDecoration gradient
- Fix round clip for Chrome 53

## 0.4.10

- Add support TextScaler

## 0.4.9

- Add support _RenderVisibility and _RenderSliverVisibility
- Fix RositaRenderParagraph size with TextOverflow.ellipsis

## 0.4.8

- Optimization HeroFlight

## 0.4.7

- Add support TextOverflow

## 0.4.6

- Fix switch TargetPlatform to Flutter forks

## 0.4.5

- Optimize Rosita call layout and paint

## 0.4.4

- Fix mouse press events
- Fix render to custom scale devicePixelRatio
- Optimize render with ccs transform translate
- Optimize rositaMarkNeedsLayout
- Refactor rositaVisitChildren
- Optimize method Hero._allHeroesFor with rositaVisitChildren
- Fix repaint text field on change obscureText property
- Add support RenderTransform alignment
- Optimize set style transform
- Optimize Rosita images set style property
- Optimize rositaDetach

## 0.4.3

- Fix paintChild when hasHtmlElement
- Fix text height

## 0.4.2

- Fix text size in table cell
- Fix TextField size
- Fix cursor hit test for some cases
- Add support MemoryImage and revoke blob object
- Fix stack children render objects orders on change widget list

## 0.4.1

- Fix text field cursor animation
- Fix paint text size for TextPainter
- Fix paint on canvas with overflow
- Fix clip path for Chrome < 55

## 0.4.0

- Add rosita_engine
- Version up Flutter to 3.13.4

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
- Disable calls updateCompositingBits, add constant rositaDisableUpdateCompositingBits (
  ROSITA_DISABLE_UPDATE_COMPOSITING_BITS)
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
