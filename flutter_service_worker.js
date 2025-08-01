'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"assets/assets/most_likely_to/en/questions.txt": "e93b7e8bab5157de8dde2f5cc9a102de",
"assets/assets/most_likely_to/questions.txt": "ba164d4bd86a42b06527de93afdf07fe",
"assets/assets/most_likely_to/es/questions.txt": "f954cc5cf639cadd5cb7276a8e10bc81",
"assets/assets/most_likely_to/pt/questions.txt": "ba164d4bd86a42b06527de93afdf07fe",
"assets/assets/forbidden_word/en/words.txt": "0e7c4c01a41820c519a68a8f0261ddb4",
"assets/assets/forbidden_word/es/words.txt": "67d14e5fb8fe93cc587bcc0fa47e9be3",
"assets/assets/forbidden_word/pt/words.txt": "f8a7923bf4965e332d3db3190aed8716",
"assets/assets/forbidden_word/words.txt": "f8a7923bf4965e332d3db3190aed8716",
"assets/assets/paranoia/en/questions.txt": "85bd25df88cec01e264ea3f35ee6e831",
"assets/assets/paranoia/questions.txt": "8b5e8a5d73c5f7a2bd7f7e6ebf2706c5",
"assets/assets/paranoia/es/questions.txt": "99fdf0c9952a31071a6f0bcee5d8c1a0",
"assets/assets/paranoia/pt/questions.txt": "8b5e8a5d73c5f7a2bd7f7e6ebf2706c5",
"assets/assets/mystery_verb/en/verbs.txt": "0b75cc185ff4ba98e5860e5e794a803e",
"assets/assets/mystery_verb/verbs.txt": "67d1e3406e187c280436777978bd249a",
"assets/assets/mystery_verb/es/verbs.txt": "6d854e94099981cfff623d6c0865bb43",
"assets/assets/mystery_verb/pt/verbs.txt": "67d1e3406e187c280436777978bd249a",
"assets/assets/images/flutter_logo.png": "478970b138ad955405d4efda115125bf",
"assets/assets/images/3.0x/flutter_logo.png": "b8ead818b15b6518ac627b53376b42f2",
"assets/assets/images/2.0x/flutter_logo.png": "4efb9624185aff46ca4bf5ab96496736",
"assets/assets/cards/en/challenges.txt": "44f33c996deab359923e2b18e0d24158",
"assets/assets/cards/es/challenges.txt": "abeab83990bf05ee3c6d6e1b1353cf23",
"assets/assets/cards/challenges.txt": "631ac257be306e1621987c184b64956d",
"assets/assets/cards/pt/challenges.txt": "631ac257be306e1621987c184b64956d",
"assets/assets/never_have_i_ever/en/questions.txt": "c89e473f8eed68bf788848d6a01f4bba",
"assets/assets/never_have_i_ever/questions.txt": "34e15b4704395902534521362cd3c324",
"assets/assets/never_have_i_ever/es/questions.txt": "16dd444f572aa4ddb64f4fcdbea08eb0",
"assets/assets/never_have_i_ever/pt/questions.txt": "34e15b4704395902534521362cd3c324",
"assets/assets/fonts/Mesmerize-Sb.otf": "4c90d64f762e8a2ebb22465323faa6fd",
"assets/assets/fonts/Mesmerize-Eb.otf": "6cbc9453a13f9871e3dc3e35b52c6d01",
"assets/assets/fonts/Mesmerize-Lt.otf": "d4ba06904c1c3e8b075caf65238a866f",
"assets/assets/fonts/Mesmerize-Bk.otf": "b1ddf8123d23a17c9b0ce7176612c3c7",
"assets/assets/fonts/RabbidHighwaySignII.otf": "e979d21f3cb66a3ff00092257f7206ac",
"assets/assets/fonts/Mesmerize-Bd.otf": "2a0491198eddb25c95fbc5f4db450f82",
"assets/assets/fonts/Mesmerize-Rg.otf": "c25dd7431d6451ae22ee29176b366a6f",
"assets/assets/fonts/Mesmerize-Ui.otf": "7edb715dfecf8fc6c0abd307b1b1db46",
"assets/assets/fonts/Mesmerize-El.otf": "f5da8bad9b0a1b8adc4973edc04f205a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/AssetManifest.bin.json": "7f8270eaa30c9c1c374ea8ab17156342",
"assets/AssetManifest.bin": "071b96252096c2c063e39a07c0f22613",
"assets/NOTICES": "9ea6d4dcb93abed0e615e187e0cb4be7",
"assets/AssetManifest.json": "a05da18c8f6cb24ed68153338a5ec030",
"assets/fonts/MaterialIcons-Regular.otf": "65c88e8f71926b7621c279a062bf4136",
"assets/FontManifest.json": "0e27e7504a4bda92c00d1051cc363162",
"flutter_bootstrap.js": "aeac5932d6e619b8423fa01e5b980da7",
"main.dart.js": "eaa597527bfd7559f25dd093e25a6174",
"manifest.json": "15f2c2e03fac17bad60bcd0f1790c437",
"favicon.png": "bc0125c993489909741feb5f40ca048c",
"version.json": "eab342a31d9efa708cbb4f81f50246c9",
"icons/Icon-192.png": "a176371bb8f68ddcce4210474a5d785a",
"icons/Icon-maskable-512.png": "8447314e911648c084f91170782687d0",
"icons/Icon-maskable-192.png": "a176371bb8f68ddcce4210474a5d785a",
"icons/Icon-512.png": "8447314e911648c084f91170782687d0",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"index.html": "57f534d38eeb9b0f339c140eb42e8782",
"/": "57f534d38eeb9b0f339c140eb42e8782"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
