[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://www.apple.com/ios/ios-10/)
[![Swift Version](https://img.shields.io/badge/swift-3.0-yellow.svg?style=flat)](https://swift.org)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)

# PhotoEffects

### Applying filters to user's photos. Saving with Core Data. 

Приложение позволяет применять разные фильтры к сделанным фотографиям и сохранять получившийся результат. Возможно добавление location и tags с возможностью дальнейшей фильтрации. 
Можно использовать как камеру, так и user’s photo library (в случае если камера недоступна).  

<br>
<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/25774650/767c9574-329c-11e7-9250-6076b545ea52.jpg" alt="Image") />
  <img src="https://cloud.githubusercontent.com/assets/23423988/25774651/76a5d56a-329c-11e7-89c3-fb09a368af93.png" alt="Image") />
</p>

Если пользователь выбрал камеру, то сделав снимок (с фронтальной либо основной), осуществляется переход на экран выбора фильтров, каждый из которых сразу отражается на исходном изображении.  

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/25776431/a985c88a-32c6-11e7-904d-97695c965c3c.png" alt="Image") />
</p>

После выбора фильтра осуществляется переход на экран с метаданными к фотографии: местоположение (`CoreLocation`, на усмотрение пользователя) и tag для каждой фотографии (с целью облегчения дальнейшего поиска).  

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/25494430/4716e864-2b82-11e7-82cd-25bb6f0728f5.png" alt="Image") />
</p>

После нажатия "Save", происходит сохранение данных (using `CoreData`) - Photo, Location, Tag, Date (когда сделана фотография, `Date` class) и возврат на основной экран. Фотографиями с применёнными фильтрами наполняется `UICollectionView` on main screen.  

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/25776432/a9dcee80-32c6-11e7-81a3-ca3490a8e571.png" alt="Image") />
</p>

Также реализована возможность сортировки и отображения конкретных фотографий по Tag или вывод всех фото без сортировки.  

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/25494431/471a42b6-2b82-11e7-980e-b4f5838a0b98.png" alt="Image") />
  <img src="https://cloud.githubusercontent.com/assets/23423988/25776430/a9859036-32c6-11e7-97f8-edc106b5ef02.png" alt="Image") />
</p>

## Used  

- Swift 3.0
- UI programmatically. No Story Board, no `.xib` files. 
- Access to camera and user’s photo library. 
- Little bit of dependency injection and delegation
- `CoreImage` `CIFilter` for applying filters
- `CIContext`, `EAGLContext`
- `UICollectionView` and `UITalbeView`
- `CoreLocation`
- `CoreData` saving and fetching
- Sorting fetched results
  
## To do

- [x] Search using tags
- [ ] Additional filters
- [ ] Fix photo rotation bug
- [ ] Overall design 

## License

PhotoEffects is available under the MIT license. See the LICENSE file for more info.
