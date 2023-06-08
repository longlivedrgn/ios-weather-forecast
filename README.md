# ☔️ 날씨 앱 프로젝트
> 오늘의 날씨와 이후 5일의 날씨를 보기 쉽게 구현한 날씨 앱입니다🌞 
## ✨ 팀 소개
| Miro(@longlivdrgn)| Sunny(@SunnnySong) |
| ------------ | ------------- |
|<img src="https://user-images.githubusercontent.com/85781941/234733559-d523576b-3475-4829-96e1-29447f9d1587.JPG" width="200" height="200"> | <img src="https://user-images.githubusercontent.com/85678496/234248105-edb205a9-9d94-45b8-ba02-8a76974c1d9a.jpeg" width="200" height="200"> |

## ✨ 기능 구현 영상
| 메인 뷰 |
| --- |
|<img src="https://github.com/longlivedrgn/ios-weather-forecast/assets/85781941/43527948-6acc-4e31-9ec2-51cfddf44709" width="250"/>|

## ✨ 기술 스택
- `CoreLocation`
- `URLSession`
- `Swift Concurrency`
    - `async`, `await`
- `CodingKeys`
- `DateFormatter`
- `NotificationCenter`

**Collection View 구현**
- `CompositionalLayout`
    - `UICollectionLayoutListConfiguration`
    - `UICollectionViewListCell`
- `Datasource`
- `RefreshControl`

  
# ✨ 프로젝트 구현

* [🔨 범용성과 재사용성, 유연성을 고려한 API 네트워크](#-범용성과-재사용성-유연성을-고려한-api-네트워크)
    * [**활용성 높은 API 설계**](#활용성-높은-api-설계)
    * [**재사용성을 높인 네트워크 코드 구현**](#재사용성을-높인-네트워크-코드-구현)
    * [**네트워크 폴더 구조**](#네트워크-폴더-구조)
 * [🔨 현재 위치를 사용하기 위한 CoreLocation](#-현재-위치를-사용하기-위한-corelocation)
  * [🔨 Collection View 구현하기](#-collection-view-구현하기)
      * [1️⃣ Layout](#1️⃣-layout)
      * [2️⃣ DataSource](#2️⃣-datasource)
      * [3️⃣ List Configuration](#3️⃣-list-configuration)
      * [4️⃣ extension의 활용](#4️⃣-extension의-활용)
  * [🔨 View Model의 업데이트를 UI에 반영하기](#-view-model의-업데이트를-ui에-반영하기)
  * [🔨 Swift Style Guideline](#-swift-style-guideline)
  * [🔨  트러블 슈팅](#--트러블-슈팅)
      * [1. 거대해진 View Controller](#1-거대해진-view-controller)
      * [2. 문제 해결 시도 : Data Controller의 생성](#2-문제-해결-시도--data-controller의-생성)
      * [3. 새로운 문제 발생 : 가벼운 View Controller, 거대한 Data Controller](#3-새로운-문제-발생--가벼운-view-controller-거대한-data-controller)
      * [4. 문제 해결 시도 : SRP를 지킨 View Model](#4-문제-해결-시도--srp를-지킨-view-model)
  * [🔨 Async, Await의 활용](#-async-await의-활용)
 
## 🔨 범용성과 재사용성, 유연성을 고려한 API 네트워크
### **활용성 높은 API 설계**

#### API URL을 어떻게 관리해야 할까?

해당 프로젝트는 OpenWeatherAPI를 사용해요. 
사용하는 API는 한 개이지만, 필요한 정보에 따라 URL주소가 변경되기도 하고 만약 여러 API를 사용하게 된다면 어떻게 URL을 관리해야 할까? 라는 생각이 들었어요.

> 저희가 생각한 방법은 URL extension과 API 타입 생성, 두 가지 입니다.

1.  **URL extension으로 모든 API를 관리한다.**

![](https://user-images.githubusercontent.com/85781941/225845595-f9c364f7-8096-4de1-bb48-1b0ed9bd847f.png)
➡️ URL extension으로 각 API 마다 URL을 만들어 반환하는 메서드를 생각했어요.

</br>

2.  **API의 타입 안에서 URL을 관리한다.**
```swift
func makeWeatherURL(coordinate: Coordinate) -> URL {
        
        let queryItems = "\(coordinate.description)&units=metric&appid="
        let apiKey = APIKeyManager.openWeather.apiKey
        
        return URL(string: WeatherAPI.baseURL + self.path + queryItems + apiKey)!
    }
```
➡️ 각 API를 관리하는 타입을 만들어 내부에서 URL 요소를 관리하는 방법이에요.
➡️ 해당 타입 안에서 URL을 만들어 반환하는 메서드를 생성해요.

</br>

3. **최종 구현한 방법**
- 저희는`API 타입 생성` 으로 구현했어요.
- 첫 번째 방법은 사용하는 API 수가 적고, URL을 구성하는 요소들이 단순해 큰 변경이 없을 때 적합한 방법이에요.
- 두 번째 방법은 프로젝트에서 사용하는 API수가 많고 URL을 구성하는 요소들이 복잡할 때 URL 관리가 용이해지는 방법이에요.
- 이번 프로젝트에서 사용하는 API는 한 개이지만, `currentWeather`와`fiveDaysForecast` 별 사용하는 path가 다르고 이미지를 가져오는 URL까지 
- 존재하기 때문에 두 번째 방법이 더 적합하다 생각했어요.



</br>


#### `currentWeather`, `fiveDaysForecast` 의 URL 구성

- URL은 크게 `baseURL`, `path`, `query`로 나눠져 있어요. 
```swift
enum WeatherAPI: String {
    
    case currentWeather
    case fiveDaysForecast
}

extension WeatherAPI {
    
    static let baseURL = "https://api.openweathermap.org"
    static let baseImageURL = "https://openweathermap.org"
    
    var path: String {
        
        switch self {
        case .currentWeather:
            return "/data/2.5/weather?"
            
        case .fiveDaysForecast:
            return "/data/2.5/forecast?"
        }
    }
}
```
- `WeatherAPI`를 enum 타입으로 구현해, path를 설정할 때 `switch문`으로 각 정보별 path를 설정해주었어요.
- 날씨 정보를 가져오는 URL과 이미지를 가져오는 URL이 다르기 때문에 두 개의 `baseURL`을 설정했어요.

</br>

#### OpenWeather API의 데이터 형식에 맞는 DTO 설계

- CodingKeys의 활용
    - `DTO(Data Transfer Object)`란, 서버에서 받아온 데이터를 앱에 적합한 형태로 변환해주는 객체에요.
    - `JSONDecoder`를 사용하면 JSON 데이터의 Key와 DTO(Decodable을 채택한)의 프로퍼티를 매핑할 수 있어요.
    - 이때 JSON 데이터의 Key와 DTO의 프로퍼티 이름이 같지 않으면, 데이터 처리에 실패해요.
    - 저희는 이런 문제를 방지하고자 DTO 내부에 `CodingKeys`를 정의해주었어요.

- `CLLocation` 대신 `Coordinate` 타입을 선언했어요.
    - 프로젝트 로직에서 longitude, latitude는 많이 사용되고 있어요.
    - 만약 `CLLocation`을 사용하면, 위도와 경도를 사용하는 모든 파일에 `import CoreLocation` 를 선언해야 해요.
    - `CoreLocation`의 `CLLocation`만 사용하기 위해 import를 하는 것은 불필요한 빌드 시간을 발생시킬 수 있어요. 
    - 저희는 프로젝트 파일이 필요한 모듈만 가져올 수 있도록 위도와 경도를 프로퍼티로 갖는 `Coordinate` 타입을 선언했어요.

</br>

### **재사용성을 높인 네트워크 코드 구현**

#### SRP를 만족하는 네트워킹 타입 구현

* 재사용성을 높이기 위해 `단일 책임 원칙`에 맞는 네트워킹 타입을 구현하려고 노력했어요.
* OpenWeatherAPI 뿐만 아니라 다른 API의 네트워킹 요청까지 처리할 수 있어 범용성과 재사용성을 만족시키는 타입을 만들었어요.


* 네트워크 코드를 설명하기 전, 더 쉬운 이해를 위해  네트워크 구조를 시각화 해봤어요.
<img src="https://i.imgur.com/lhTXD0d.jpg" width="600" height="600">


#### NetworkSession.swift

```swift
final class NetworkSession {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData(from urlRequest: URLRequest) async throws -> NetworkResult {
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard response.checkResponse else {
            return .failure(.outOfReponseCode)
        }
        
        return .success(data)
    }
}
```
- **`NetworkSession`** 타입은 네트워크 요청을 전송하는 책임을 갖고 있어요.
    - **`fetchData(from:)`** : `URLRequest` 를 인자로 받아 네트워크 요청을 전달하고, 그 결과를 반환해요.

</br>

```swift
typealias NetworkResult = Result<Data, NetworkError>
```
- 네트워크 결과는 Result 타입으로 구현된 `NetworkResult` 를 사용했어요.
    - 네트워크 결과가 성공일 경우 받아오는 데이터와 실패할 경우 반환되는 `NetworkError`를 하나의 **Result**타입으로 `캡슐화` 했어요.


#### WeatherNetworkDispatcher.swift

```swift
func makeWeatherRequest(of weatherAPI: WeatherAPI, in coordinate: Coordinate) -> URLRequest {
        
    let url = weatherAPI.makeWeatherURL(coordinate: coordinate)
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
        
    return urlRequest
}
```

- **`makeWeatherRequest(of:in:)`** : 날씨 정보를 받기 위한 네트워크 요청을 만드는 메서드에요.

</br>

```swift
func requestWeatherInformation(of weatherAPI: WeatherAPI,
                                   in coordinate: Coordinate) async throws -> Decodable? {
        
    let urlRequest = makeWeatherRequest(of: weatherAPI, in: coordinate)
    let result = try await networkSession.fetchData(from: urlRequest)
        
    switch result {
    case .success(let data):
        guard let decodeData = try self.deserializer.deserialize(data: data, to: weatherAPI.decodingType) else { throw NetworkError.failedDecoding}
        return decodeData
            
    case .failure(let error):
        print(error.errorDescription)
        return nil
    }
}
```
- **`requestWeatherInformation(of:in:)`** : **`NetworkSession.fetchData(from:)`** 을 사용해 비동기 네트워크 요청을 보내고 그 결과를 case별로 처리해요.
    - Result 타입의 네트워크 결과를 switch문으로 처리해 손 쉬운 error Handling을 구현해보았어요.

</br>

```swift
private let deserializer = JSONNetworkDeserializer(decoder: JSONDecoder())
```
- 성공했을 경우, 전달된 데이터를 `JSONNetworkDeserializer()`을 사용해 각 데이터에 알맞는 DTO 타입으로 변환해주었어요.

</br>

### **네트워크 폴더 구조**

| ![](https://i.imgur.com/dkCL231.png) |
|:------------------------------------:|
- **Serialization** : 데이터를 특정 형식으로 변환하는 타입을 가진 폴더에요.
    - Serialization은 Deserializer, Serializer 을 모두 포함하지만, 이번 프로젝트에서는 Deserializer만 구현했어요.
- **Error** : 네트워크 에러를 정의해 놓은 폴더에요.
- **DTO** : Serialization에 사용하는 데이터 전송 객체를 모아 놓은 폴더에요.
    - 해당 프로젝트에서는 API를 통해 두 가지의 데이터를 전송받기 때문에 두 개의 DTO를 생성했어요.
- **Model** : 네트워크에 필요한 모델을 정의해 놓은 폴더에요.
- **API** : API와 통신하는데 필요한 파일이 담긴 폴더에요.
    - **APIKeys** :  API의 Key 관리 폴더에요.
        - 실제 API Key는 APIKeys 파일에 넣고 .gitignore에 추가했어요.
        - APIKeyManager로 APIKey에 접근해 보안성을 높혔어요.

</br>


## 🔨 현재 위치를 사용하기 위한 CoreLocation

### CoreLocationManager 타입 구현
- `CLLocationManagerDelegate` 프로토콜을 채택한 CoreLocationManager 타입을 구현했어요.
    - 처음 구현에서는 `CLLocationManager`을 직접 상속한 타입을 만들었어요.
    - 하지만 `CLLocationManager`은 iOS의 내부적인 System Framework로, 일부 메서드를 오버라이드 하는 것은 권장되지 않는다는 사실을 알게 되었어요.
- `CLLocationManagerDelegate` 프로토콜을 채택해 `CLLocationManager`가 트리거한 이벤트에 대한 응답을 설정해주었어요.
- CLLocationManager의 프로퍼티인 location이 업데이트 되면, `CoreLocationManagerDelegate` 를 통해 `WeatherViewModel`에게 현재 위치를 전달해주었어요.


## 🔨 Collection View 구현하기
- Table View와 같은 list 형식의 Collection View를 구현하기 위하여 애플 공식문서 [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)를 참고하여 `Compositional Layout`를 활용해 Collection View를 구현했어요. 아래는 저희가 이와 같은 스택을 결정하게된 고민의 과정이에요.

### 1️⃣ Layout
- 저희는 두 가지 방식의 collection view의 layout 구현하는 방법을 고려해보았어요.
    - DelegateFlowLayout
    - CompositionalLayout

**DelegateFlowLayout**
- 해당 방법은 가장 기본적인 Collection View의 레이아웃을 구현하는 방법이에요. 이 방법은 아이템 간 간격, 행과 열의 갯수 등을 구성할 수 있는 메서드를 제공하므로 비교적 간단한 형태의 Collection View의 레이아웃을 구현할 때 활용할 수 있어요.

**CompositionalLayout**
- `DelegateFlowLayout보다` 더 세밀하게 레이아웃을 지정할 수 있고, 각 섹션 별로 다른 형태의 그리드를 구성할 수 있도록 해요.

> 처음 Collection View를 구현할 때는 굳이 `CompositionaLayout을` 활용하는 게 아닌 `DelegateFlowLayout을` 통해서 구현할 수 있다고 생각했지만, [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)에서 소개된 `UICollectionLayoutListConfiguration를` 활용하기 위해서는 `CompositionalLayout`을 활용해야되었어요. 따라서 `CompositionalLayout`으로 레이아웃을 구현하기로 결정했어요.


### 2️⃣ DataSource
- 저희는 Collection View의 Datasource를 구현하기 위해서 아래와 같은 두 가지 방식을 고려했어요.
    - DiffableDatasource
    - Datasource

**Datasource**
-  가장 기본적으로 Collection View Cell의 Data를 구현하는 방식으로 Collection View의 섹션 수, 각 섹션의 항목 수, 셀 구성 및 구성된 셀에 대한 데이터 제공 등을 제공해요.

**DiffableDatasouce**
- Collection View의 데이터 업데이트를 더 손쉽게 하기 위해서 발전된 Datasource 구현 방법이에요. `NSDiffableDataSourceSnapshot` 객체를 통하여 데이터 소스의 변경사항을 체크하고 스냅 샵을 통하여 변경된 데이터 소스를 통하여 Collection View를 업데이트해요.

> 저희는 매번 reloadData()를 통하여 collection view를 업데이트를 하는 `DataSource`보다 스냅샷을 통하여 리소스 낭비 없이 Collection View 업데이트를 하는 `DiffableDatasource`를 활용하려고 했어요. 그러나, HeaderView에 다른 데이터 소스가 필요한 저희 프로젝트에서 `DiffableDatasource`를 활용할 경우 Datasource를 두 개를 만들어야하므로 비효율적이라는 생각이 들었어요. 또한, 지속적인 collection View의 업데이트가 일어나야되는 것이 아닌 `refreshControl`을 통해서만 업데이트되는 현재의 조건에서는 굳이 `DiffableDatasource`를 활용하지 않아도 된다는 판단이 들어 기본 `Datasource`를 활용하기로 결정했어요.

### 3️⃣ List Configuration
- 저희는 Table View와 같이 생긴 Collection View를 더욱 손쉽게 구현하기 위하여 `UICollectionLayoutListConfiguration`를 활용하기로 했어요. 이를 통해서 굳이 Cell의 사이즈를 설정할 필요없이 원하는 모습의 Collection View를 구현할 수 있었어요.

```swift
private func createLayout() -> UICollectionViewLayout {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        
        configuration.headerMode = .supplementary
        configuration.backgroundColor = .clear
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
```
- 또한, cell Configuration을 통하여 cell안의 layout을 따로 잡아주지 않고 이미 구현된 layout을 활용하여 cell의 layout을 구현할 수 있었어요.

```swift
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var configuration = ...
        
        contentConfiguration = configuration
    }
```

### 4️⃣ extension의 활용
- 반복되어 사용되는 UICollectionReusableView reuseIdentifier를 extension으로 빼주어 reuseIdentifier가 반복되어 하드 코딩되는 것을 피할 수 있었어요.

```swift
extension UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
```
- 또한, cell을 register할 때에 reuseIdentifier와 class를 따로 넣어주는 것이 아닌 동시에 넣어줄 수 있게 하여 훨씬 더 간결하게 view controller 코드를 구성할 수 있도록 했어요.

```swift
extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cell: T.Type) {
        
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(header: T.Type) {
        
    }
```

- 이 뿐만아니라 dequeue 메소드 또한 아래와 같은 extension으로 구현하여 더 간결하게 코드를 구성할 수 있어용.

```swift
    func dequeue<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
        
        return dequeueReusableCell(withReuseIdentifier: cell.reuseIdentifier, for: indexPath) as! T
    }
```

## 🔨 View Model의 업데이트를 UI에 반영하기
<img src="https://i.imgur.com/hr4vUMs.jpg" width="600" height="400">
- 기존에는 Delegate 패턴을 통하여 View Model의 업데이트 상황을 View Controller에게 알려주었어요.
- 하지만 ViewModel, Model의 경우 `Observer 패턴(Notification Center, RxSwift, Combine)`을 활용함을 알게되었고, 최종적으로 `NotificationCenter`를 활용했어요.

```swift
// 🔥 WeatherViewModel
NotificationCenter.default.post(name: Notification.Name.modelDidFinishSetUp, object: nil)

// 🔥 WeatherViewController
NotificationCenter.default.addObserver(self, selector: #selector(modelDidFinishSetUp(_:)), name: Notification.Name.modelDidFinishSetUp, object: nil)
```

## 🔨 Swift Style Guideline
> 저희는 동료와 수월한 협업 및 코드의 가독성을 위하여 Swift Style Guideline 및 kodecocodes의 sytle guide를 참고하여 코드를 짜려고 노력했어요.

### Delegate 메소드 네이밍
- `CoreLocationManagerDelegate`
- `WeatherViewModelDelegate` 
    - UIKit의 대부분의 delegate 메소드가 그러하듯 delegate 메소드의 첫 번째 파라미터는 delegate 소스를 받도록 했어요.
```swift
// 🌈 CoreLocationManagerDelegate
protocol CoreLocationManagerDelegate: AnyObject {
    
    func coreLocationManager(_ manager: CoreLocationManager, didUpdateLocation location: CLLocation)
}

// 🌈 WeatherViewModelDelegate
protocol WeatherViewModelDelegate: AnyObject {
    
    func weatherViewModelDidFinishSetUp(_ viewModel: WeatherViewModel)
}
```
### Network 네이밍
> `재사용성을 높인 네트워크 코드 구현` 파트에서 설명드린 대로 저희는 각 네트워크 계층의 메소드 명과 타입 명을 확실히 분리하여 가독성을 높일 수 있었어요.

**NetworkSession**
- `fetch` 메소드를 통하여 네트워크 요청을 전송하는 책임을 갖고 있어요.
- Network 계층에서 가장 하단에 위치한 타입이에요.

**WeatherNetworkDispatcher**
- `request` 메소드를 통하여 `NetworkSession`의 `fetch` 메소드를 호출하여 최종적으로 Data를 받아오는 타입이에요.
- Network 계층에서 `NetworkSession`의 상위 단계의 타입이에요.

**WeatherViewModel**
- `execute` 메소드를 통하여 `weatherNetworkDispatcher의` `request` 메소드를 호출하여 API 호출을 통하여 최종적으로 원하는 Model을 생성하는 타입이에요.
    
        
## 🔨  트러블 슈팅

### 1. 거대해진 View Controller

- 기존의 ViewController의 경우, `CoreLocation`을 통하여 위치를 받아오기 위해 `CLLocationManagerDelegate`을 채택했어요.
- API 통신으로 받아온 데이터를 Collection View에서 보여주기 위한 로직을 담고있어야했어요.

```swift
// 기존 ViewController 코드
class WeatherViewController: UIViewController {

    private let networkModel = NetworkModel()
    private lazy var network = WeatherAPIManager(networkModel: networkModel)
    private let locationDelegate = LocationManagerDelegate()

    lazy var coreLocationManger: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestWhenInUseAuthorization()
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        coreLocationManger.delegate = locationDelegate
       
             
            network.fetchWeatherInformation(
            of: .currentWeather,
            // 예시 위도 경도    
            in: Coordinate(longitude: 126.96368972, latitude: 37.53361968)
        )
    }
}
```

- 그러던 중, [뷰 컨트롤러는 죄가 없다](https://www.sungdoo.dev/programming/do-not-blame-mvc-1) 라는 아티클을 보게되었어요.
해당 아티클에서 쓰여진 말처럼, 저희의 코드는 네트워크 API콜을 하고 response를 받아 View에 띄우는 것 까지 모두 View Controller이 담당하고 있었어요. 저희는 이러한 코드는 View Controller에게 너무 큰 책임을 주는 것이라고 생각이 들었어요.

</br>

### 2. 문제 해결 시도 : Data Controller의 생성

- 문제를 인식한 뒤, View Controller가 View에 데이터를 present해주는 로직만 담기로 결심했어요.
    - View들을 관리하는 View Controller처럼, Data들을 관리하는 **`Data Controller`** 파일을 생성하기로 했어요.
    - 네트워크 API를 호출하고, 결과를 받아 View에 보여주기 위한 타입으로 변환하는 로직 등 데이터 관련 로직을 `Data Controller`에서 구현했어요.
- Apple Documentation의 [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views) 예제 프로젝트를 참고했어요.
    - 저희는 이 프로젝트의 `MountainsController` 파일이 Data Controller 역할을 한다고 생각했어요. `MountainsController`는 Collection View에 데이터를 띄워주기 위해 Mountains 데이터 셋을 만들고 있어요.
- 따라서, 저희는 ViewController와는 다른 Data Controller 파일을 생성하게 되었어요.
    - Data Controller 파일에서는 CoreLocation의 알림을 받고, API 통신과 관련된 로직이 포함되어 있어요. 
    - 또한 Collection View에서 사용할 FiveDaysForecast 구조체와 CurrentWeather 구조체가 존재해요.

</br>

### 3. 새로운 문제 발생 : 가벼운 View Controller, 거대한 Data Controller 

- 리팩토링을 통해 가벼운 View Controller를 얻었지만, 그에 반해 매우 많은 로직을 담은 Data Controller를 만들게 되었어요.
- 현재 Data Controller에는 CurrentWeather, FiveDaysForecast 두 개의 타입을 모두 다루고 있어요.

```swift
final class WeatherController {

    struct CurrentWeather: Identifiable {
        let id = UUID()
        let image: UIImage?
        let address: String
        let temperatures: Temperature
    }

    struct FiveDaysForecast: Identifiable {
        let id = UUID()
        var image: UIImage?
        let date: String
        let temperature: Double
    }

    private var weatherAPIManager: WeatherAPIManager?
    private let locationManager = LocationManager()

    weak var currentWeatherDelegate: CurrentWeatherDelegate?

    var currentWeather: CurrentWeather?
    var forecaseWeather: [FiveDaysForecast] = []

    init(networkModel: NetworkModel = NetworkModel(session: URLSession.shared)) {
        weatherAPIManager = WeatherAPIManager(networkModel: networkModel)

        locationManager.locationDelegate = self
    }

    // CLLocation -> Coordinate 변환 함수
    func makeCoordinate(from location: CLLocation) -> Coordinate {
        // ...
    }

    // API 통신 후 decoded 한 CurrentWeatherDTO를 CurrentWeather 타입으로 변환하는 함수
    private func makeCurrentWeather(location: CLLocation) {
         // ...
    }

    // API 통신 후 decoded 한 FiveDaysForecastDTO를 FiveDaysForecast 타입으로 변환하는 함수
    private func makeForecastWeather(location: CLLocation) {
        // ...
    }
}

    func makeWeatherData(location: CLLocation) {
        makeCurrentWeather(location: location)
        makeForecastWeather(location: location)
    }

}

extension WeatherController: LocationDelegate {
    func send(location: CLLocation) {
        makeWeatherData(location: location)
    }

}

```


</br>

### 4. 문제 해결 시도 : SRP를 지킨 View Model

- **SRP**란, 클래스는 하나의 기능만 가지며, 클래스가 제공하는 모든 서비스는 하나의 책임을 수행하는데 집중되어야 한다는 SOLID 원칙 중 하나에요.
- 기존 코드는 `WeatherController` 안에 `CurrentWeather`와 `FiveDaysForecast`가 존재하고, DTO 데이터를 각 타입으로 변환하는 두 개의 서비스를 갖고 있어요. 이러한 `WeatherController`는 SRP 원칙을 위배하는 코드라고 생각했어요.
- `WeatherController`를  `CurrentWeatherViewModel` 과 `FiveDaysForecastWeatherViewModel`로 분리했어요.
    - 저희는 DataController라는 네이밍 보다는 View Controller에서 사용하는 Model이라는 뜻에서 ViewModel이라는 네이밍 더 명시적이라고 생각했어요.

</br>

**CurrentWeatherViewModel.swift**
- CurrentWeatherViewModel 파일은 CurrentWeather 타입과 그에 관련된 서비스만을 다루고 있어요.

```swift
final class CurrentWeatherViewModel {

    struct CurrentWeather: Identifiable {
        let id = UUID()
        let image: UIImage?
        let address: String
        let temperatures: Temperature
    }

    func makeCurrentAddress(locationManager: CoreLocationManager,
                            location: CLLocation,
                            completion: @escaping (String) -> Void
    ) {
        // ...
    }

    func makeCurrentInformation(weatherAPIManager: WeatherAPIManager?,
                                coordinate: Coordinate,
                                location: CLLocation,
                                address: String,
                                completion: @escaping (String, CurrentWeatherDTO) -> Void
    ) {
        // ...
    }

    func makeCurrentImage(weatherAPIManager: WeatherAPIManager?,
                          iconString: String,
                          address: String,
                          weatherData: CurrentWeatherDTO
    ) {
             // ...
            // 추후 WeatherViewModel로 전달하는 Delegate 구현
        }
    }
}

```


</br>

**FiveDaysForecastWeatherViewModel.swift**
- FiveDaysForecastWeatherViewModel 타입은 FiveDaysForecast 타입과 그에 관련된 서비스만을 다루고 있어요.


```swift
final class FiveDaysForecastWeatherViewModel {

    struct FiveDaysForecast: Identifiable {
            let id = UUID()
            var image: UIImage?
            let date: String
            let temperature: Double
        }

    func makeForecastWeather(weatherAPIManager: WeatherAPIManager?,
                                 coordinate: Coordinate,
                                 location: CLLocation,
                                 completion: @escaping (String, Day) -> Void
        ) {
             // ...
        }

        func makeForecastImage(weatherAPIManager: WeatherAPIManager?,
                               icon: String,
                               eachData: Day
        ) {
                // ...
                // 추후 WeatherViewModel로 전달하는 Delegate 구현

            }
        }
}

```

</br>

**WeatherViewModel.swift**

```swift
final class WeatherViewModel {

    private let fiveDaysForecastWeatherViewModel = FiveDaysForecastWeatherViewModel()
    private let currentWeatherViewModel = CurrentWeatherViewModel()

    private let locationManager = CoreLocationManager()
    private let weatherAPIManager: WeatherAPIManager?

    var fiveDaysForecastWeather: [FiveDaysForecastWeatherViewModel.FiveDaysForecast] = []
    var currentWeather: CurrentWeatherViewModel.CurrentWeather?

    init(networkModel: NetworkModel = NetworkModel(session: URLSession.shared)) {
        weatherAPIManager = WeatherAPIManager(networkModel: networkModel)

        locationManager.locationDelegate = self
    }

    func makeCoordinate(from location: CLLocation) -> Coordinate {
        // ...
    }

    func makeWeatherData(locationManager: CoreLocationManager, weatherAPIManager: WeatherAPIManager?) {

        // currentWeather 만드는 메서드 호출
        currentWeatherViewModel.makeCurrentAddress(
            locationManager: locationManager,
            location: location
        ) { [weak self] address in

            self?.currentWeatherViewModel.makeCurrentInformation(
                weatherAPIManager: weatherAPIManager,
                coordinate: coordinate,
                location: location,
                address: address
            ) { [weak self] iconString, weatherData in

                self?.currentWeatherViewModel.makeCurrentImage(
                    weatherAPIManager: weatherAPIManager,
                    iconString: iconString,
                    address: address,
                    weatherData: weatherData
                )
            }
        }

        // fiveDaysForecast 만드는 메서드 호출
        self.fiveDaysForecastWeatherViewModel.makeForecastWeather(
            weatherAPIManager: weatherAPIManager,
            coordinate: coordinate,
            location: location
        ) { [weak self] iconString, eachData in

            self?.fiveDaysForecastWeatherViewModel.makeForecastImage(
                weatherAPIManager: weatherAPIManager,
                icon: iconString,
                eachData: eachData
            )
        }
    }
}

extension WeatherViewModel: LocationDelegate {
    func didUpdateLocation() {
        makeWeatherData(
            locationManager: locationManager,
            weatherAPIManager: weatherAPIManager
        )
    }
}

```

- 또한 변환한 데이터 셋을 가지며 View Controller와 통신하는 WeatherViewModel 타입을 만들었어요.


## 🔨 Async, Await의 활용

- 데이터 모델을 만들기 위해서는 기본적으로 여러 번의 API 호출을 거쳐야됐어요. Current Weather의 경우, 아래의 순서를 거쳐서 객체가 생성되요.
    1. CLGeocoder().reverseGeocodeLocation 메서드를 사용해 현재의 주소를 받아와요.
    2. 경도, 위치 정보를 통하여 CurrentWeatherDTO를 생성해요.
    3. CurrentWeatherDTO의 icon 프로퍼티 값을 통하여 icon Image를 받아오는 API 통신을 해요.
    4. 최종적으로 CurrentWeather 객체를 생성해요.
- 이러한 로직을 통하여 코드를 구현하니 아래와 같은 코드가 생성되었어요.

```swift
func makeCurrentWeather(location: CLLocation) {

        // 1. coordinate 주소 가져오기
        let coordinate = self.makeCoordinate(from: location)

        // 2. address 생성하기
        locationManager.changeGeocoder(location: location) { [weak self] place in

            guard let locality = place?.locality, let subLocality = place?.subLocality else { return }

            let address = "\\(locality) \\(subLocality)"

            // 3. currentWeather 가져오기
            self?.weatherAPIManager?.fetchWeatherInformation(of: .currentWeather, in: coordinate) { [weak self] data in
                let group = DispatchGroup()
                guard let weatherData = data as? CurrentWeatherDTO else { return }

                guard let icon = weatherData.weather.first?.icon else { return }

                group.enter()
                // 4. 이미지 가져오기
                self?.weatherAPIManager?.fetchWeatherImage(icon: icon) { [weak self] weatherImage in

                    self?.currentWeather = CurrentWeather(image: weatherImage, address: address, temperatures: weatherData.temperature)
                    group.leave()
                }
                group.notify(queue: .main) {
                    self?.currentWeatherDelegate?.notifyToUpdateCurrentWeather()
                }
            }
        }
    }

```

</br>

😅 *위와 같은 코드는 아래와 같은 단점을 가지고 있어요.*

### Concurrent code(GCD + CompletionHandler)의 단점

- CompletionHandler로 인해 과도한 중첩 클로저가 유발되어 코드 복잡성이 증가되었어요.
- 연속적인 completionHandler로 인해 코드의 가독성이 저하되었어요.
- 오류 처리와 같은 예외 상황 처리가 어렵기 때문에 유지보수 저하가 우려되요.
- `self property`의 접근으로 인해 `strong retain cycle` 발생 가능성이 있어요.
    - 위 코드에서 `strong retain cycle`을 막기 위해 약한 참조를 사용했지만, 이는 런타임 오버헤드를 발생시킬 수 있어요.

- 이러한 장풍 코드를 개선하기 위한 방법을 고민해봤어요.
    - DispatchGroup의 활용해 return 값으로 데이터를 전달한다.
    - async, await를 활용한다.
- 저희는 위 방법 중 async, await을 활용해보기로 하였고, 아래와 같은 코드를 완성할 수 있었어요!


### **😇 async, await를 활용하여 리팩토링한 코드는 아래와 같아요.**

### `WeatherViewModel`

```swift
// WeatherViewModel
private func execute(locationManager: CoreLocationManager,
                 location: CLLocation,
                 weatherNetworkDispatcher: WeatherNetworkDispatcher) {

        let coordinate = self.makeCoordinate(from: location)

        Task {
            let address = try await currentWeatherViewModel.fetchCurrentAddress(
                locationManager: coreLocationManager,
                location: location)

            let currentWeatherDTO = try await currentWeatherViewModel.fetchCurrentInformation(
                weatherNetworkDispatcher: weatherNetworkDispatcher,
                coordinate: coordinate
            )

            let currentWeatherImage = try await currentWeatherViewModel.fetchCurrentImage(
                weatherNetworkDispatcher: weatherNetworkDispatcher,
                currentWeatherDTO: currentWeatherDTO
            )

            let currentWeather = currentWeatherViewModel.makeCurrentWeather(
                image: currentWeatherImage,
                address: address,
                currentWeatherDTO: currentWeatherDTO
            )

            self.currentWeather = currentWeather

            let fiveDaysForecastWeatherDTO = try await fiveDaysForecastWeatherViewModel.fetchForecastWeather(
                weatherNetworkDispatcher: weatherNetworkDispatcher,
                coordinate: coordinate
            )

            let fiveDaysForecastImages = try await fiveDaysForecastWeatherViewModel.fetchForecastImages(
                weatherNetworkDispatcher: weatherNetworkDispatcher,
                fiveDaysForecastDTO: fiveDaysForecastWeatherDTO
            )

            let fiveDaysForecasts = fiveDaysForecastWeatherViewModel.makeFiveDaysForecast(
                images: fiveDaysForecastImages,
                fiveDaysForecastDTO: fiveDaysForecastWeatherDTO
            )

            self.fiveDaysForecastWeather = fiveDaysForecasts

            DispatchQueue.main.async {
                self.delegate?.weatherViewModelDidFinishSetUp(self)
            }
        }
    }

```

### `CurrentWeatherViewModel`

```swift
func fetchCurrentAddress(locationManager: CoreLocationManager,
                             location: CLLocation) async throws -> String {

        let location = try await locationManager.changeGeocoder(location: location)

        guard let locality = location?.locality, let subLocality = location?.subLocality else {
            throw NetworkError.failedTypeCasting
        }

        let address = "\\(locality) \\(subLocality)"

        return address
    }

    func fetchCurrentInformation(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                                 coordinate: Coordinate) async throws -> CurrentWeatherDTO {

        let decodedData = try await weatherNetworkDispatcher.requestWeatherInformation(of: .currentWeather, in: coordinate)

        guard let currentWeatherDTO = decodedData as? CurrentWeatherDTO else {
            throw NetworkError.failedTypeCasting
        }

        return currentWeatherDTO
    }

    func fetchCurrentImage(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                           currentWeatherDTO: CurrentWeatherDTO) async throws -> UIImage {

        guard let iconString = currentWeatherDTO.weather.first?.icon else {
            throw NetworkError.failedTypeCasting
        }
        let image = try await weatherNetworkDispatcher.requestWeatherImage(icon: iconString)
        guard let image = image else {
            throw NetworkError.failedTypeCasting
        }

        return image
    }

```

### `FiveDaysForecastWeatherViewModel`

```swift
func fetchForecastWeather(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                              coordinate: Coordinate) async throws -> FiveDaysForecastDTO {

        let decodedData = try await weatherNetworkDispatcher.requestWeatherInformation(of: .fiveDaysForecast, in: coordinate)

        guard let fiveDaysForecastDTO = decodedData as? FiveDaysForecastDTO else {
            throw NetworkError.failedTypeCasting
        }

        return fiveDaysForecastDTO
    }
    func fetchForecastImages(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                             fiveDaysForecastDTO: FiveDaysForecastDTO) async throws -> [UIImage] {

        var images: [UIImage] = []

        for day in fiveDaysForecastDTO.list {
            guard let iconString = day.weather.first?.icon else {
                throw NetworkError.failedTypeCasting
            }

            let image = try await weatherNetworkDispatcher.requestWeatherImage(icon: iconString)

            guard let image = image else {
                throw NetworkError.failedTypeCasting
            }

            images.append(image)
        }

        return images
    }

```
☺️ *위와 같은 코드는 아래와 같은 장점을 가지고 있어요.*

### Swift Concurrency(`async`, `await`)의 장점
- 콜백 지옥에서 벗어나 가독성을 향상시킬 수 있어요.
- 에러 핸들링이 쉬워져요.
- 어느 부분에서 에러가 발생했는지 확인이 용이하기 때문에 유지보수가 용이해요.
- 비동기 코드들의 작업 순서를 쉽게 제어할 수 있어요.
