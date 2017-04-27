# PhotoEffects
### Applying effects to user's photos

Приложение позволяет применять разные фильтры к сделанным фотографиям и сохранять получившийся результат. Возможно добавление location и tags с возможностью дальнейшей фильтрации. 
Можно использовать как камеру, так и user’s photo library (в случае если камера недоступна).

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/25494429/471697ec-2b82-11e7-9fe4-d26886f0b73e.jpg" alt="Image") />
  <img src="https://cloud.githubusercontent.com/assets/23423988/25494426/471056ac-2b82-11e7-94a6-db2ed72a01c9.png" alt="Image") />
</p>

Если пользователь выбрал камеру, то сделав снимок (с фронтальной либо основной), осуществляется переход на экран выбора фильтров, каждый из которых сразу отражается на исходном изображении.  

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/25494427/47132954-2b82-11e7-8be9-2cb7f234f2dd.png" alt="Image") />
</p>

После выбора фильтра осуществляется переход на экран с метаданными к фотографии: местоположение (Core Location, на усмотрение пользователя) и tag для каждой фотографии (с целью облегчения дальнейшего поиска).  

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/25494430/4716e864-2b82-11e7-82cd-25bb6f0728f5.png" alt="Image") />
</p>

После нажатия Save, происходит сохранение данных (using Core Data) - Photo, Location, Tag, Date (когда сделана фотография) и возврат на основной экран. Фотографиями с применёнными фильтрами наполняется Collection View on main screen.  

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/25494428/4714ce6c-2b82-11e7-813a-ff8dbfa88ea8.png" alt="Image") />
</p>

Также реализована возможность сортировки и отображения конкретных фотографий по Tag или вывод всех фото без сортировки.  

<p align="center">
  <img src="https://cloud.githubusercontent.com/assets/23423988/25494431/471a42b6-2b82-11e7-980e-b4f5838a0b98.png" alt="Image") />
  <img src="https://cloud.githubusercontent.com/assets/23423988/25494432/47336886-2b82-11e7-8c8c-efbe208dadb5.png" alt="Image") />
</p>

#### Использовано 
- Swift 3.0
- UI programmatically. No Story Board, no .xib files. 
- Access to camera and user’s photo library. 
- Little bit of dependency injection and delegation
- Core Image CIFilter for applying filters
- CIContext, EAGLContext
- Collection View and TalbeView
- Core Location
- Core Data saving and fetching
- Sorting fetched results
