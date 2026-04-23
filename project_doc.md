I plan to build a food ordering app. the app allows customer to browse food add to cart and make payment and place order.

First time user:
when the app starts it navigate to onboarding after he finishes onboarding it asks for notification and location access permissions
then it navigates to branch listing screen( the screen that lists all branches)
when user navigate to protected routes such as cart, profile etc.. it asks to login if he already not loggedin after ogin he can do what ever he want

Existing user:
each time user launches the app it asks for location access even if user denied the app ask consistently until he gives the permission. 
if granted if user has accesstoken he can navigate even protected routes
but the flo is always start from branch selection.

Branch selection:
after user selects the branch it navigate to home page a page that lists all foods menu. from there he can do whatever he want

Listing branchs:
we have an endpoint that returns all branches. but the branch are going to be listed based on nearest to him mean the nearest on the top. also the the get branches endpoint returns lat and long we can calculate the disptance using package like geolocation or other paid subscription

Project architecture:
the project follows clean architecture with riverpod generator such as version 3.0.3
the app should follow industry standard. everything should be reliable, professional and modern and safe. 

Packages we plan to use
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  flutter_riverpod: ^3.0.3
  go_router: ^17.0.1
  flutter_secure_storage: ^10.0.0
  dio: ^5.9.0
  another_flushbar: ^1.12.32
  retry: ^3.1.2
  flutter_spinkit: ^5.2.2
  pinput: ^6.0.1
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0
  retrofit: ^4.9.1
  cached_network_image: ^3.4.1
  dartz: ^0.10.1
  smooth_page_indicator: ^2.0.1
  riverpod_annotation: ^3.0.3
  uuid: ^4.5.2
  jwt_decode: ^0.3.1
  flutter_dotenv: ^6.0.0
  shared_preferences: ^2.5.4
  logger: ^2.6.2
  gebeta_gl: ^0.22.4
  url_launcher: ^6.3.2
  geolocator: ^14.0.2
  socket_io_client: ^3.1.3
  action_slider: ^0.7.0
  flutter_animate: ^4.5.2
  image_picker: ^1.2.1
  photo_view: ^0.15.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^6.0.0
  freezed: ^3.2.3
  riverpod_generator: ^3.0.3
  retrofit_generator: ^10.2.0
  json_serializable: ^6.11.2
  build_runner: ^2.10.4
  custom_lint: ^0.8.1
  riverpod_lint: ^3.0.3
