# GIPHY layout app

Sample iOS app for browsing, viewing and sharing GIFs from the GIPHY service.

Implement: 
- 
1. Main screen with a mosaic layout
2. Coloured tiles while loading images
3. Shimmering animation on loading
4. Share screen
5. An option to save to Photos
6. An option to copy the GIPHY link

Dependencies: 
- 
- [Gifu](https://github.com/kaishin/Gifu)

Enviroment:
- cocoapods
- xcodegen

Start Project
-
```shell
xcodegen generate
```

Project Structure
-

- `Screens`

    - contains screen in `UIViewController` + `Presenter`
    - `Configurator` for build screen and routing tasks
- `Services`

   - contains API-, stores and data-handlers services
   - api-helpers
   
- `Support`

    - App constans 
- `Extensions`

    - hmm... extensions and helpers

