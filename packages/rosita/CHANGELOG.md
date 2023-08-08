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
