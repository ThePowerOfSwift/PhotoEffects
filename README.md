# PhotoEffects
### Applying effects to user's photos

Приложение позволяет применять разные фильтры к сделанным фотографиям и сохранять получившийся результат. Возможно добавление location и tags с возможностью дальнейшей фильтрации. 
Можно использовать как камеру, так и user’s photo library (в случае если камера недоступна).

------  


Если пользователь выбрал камеру, то сделав снимок (с фронтальной либо основной), осуществляется переход на экран выбора фильтров, каждый из которых сразу отражается на исходном изображении.  

------  

После выбора фильтра осуществляется переход на экран с метаданными к фотографии: местоположение (Core Location, на усмотрение пользователя) и tag для каждой фотографии (с целью облегчения дальнейшего поиска).  

------  

После нажатия Save, происходит сохранение данных (using Core Data) - Photo, Location, Tag, Date (когда сделана фотография) и возврат на основной экран. Фотографиями с применёнными фильтрами наполняется Collection View on main screen.  

------  

Также реализована возможность сортировки и отображения конкретных фотографий по Tag или вывод всех фото без сортировки.  

------  





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
