// default-sw.js
const CACHE_NAME = "default-sw-cache-v1";

//need to cooperate with feature-toggle. configure mainifest in feature-toggle.
const PRECACHE_URLS = [
];

// install：preload resource
self.addEventListener('install', (event) => {
  console.log('[DefaultSW] Install event');
  event.waitUntil(
    (async () => {
      const cache = await caches.open(CACHE_NAME);
      await cache.addAll(PRECACHE_URLS);
      console.log('[DefaultSW] Precache completed');
    })()
  );
  self.skipWaiting();
});

// activate：clear old cache + take over page
self.addEventListener('activate', (event) => {
  console.log('[DefaultSW] Activate event');
  event.waitUntil(
    (async () => {
      const cacheNames = await caches.keys();
      await Promise.all(
        cacheNames.map((name) => {
          if (name !== CACHE_NAME) {
            console.log('[DefaultSW] Deleting old cache:', name);
            return caches.delete(name);
          }
        })
      );
      // immediately take over page
      await self.clients.claim();
      console.log('[DefaultSW] Now controlling clients');
    })()
  );
});

// fetch：cache first + background update
self.addEventListener('fetch', (event) => {
  const { request } = event;

  event.respondWith((async () => {
    const cache = await caches.open(CACHE_NAME);
    const cachedResponse = await cache.match(request);
    if (cachedResponse) {
      // Cache First
      const clone = cachedResponse.clone();
      notifyClients(request.url, 'cache', clone);

      // Background Update
      fetch(request).then(async (networkResponse) => {
        if (networkResponse && networkResponse.status === 200) {
          await cache.put(request, networkResponse.clone());
          notifyClients(request.url, 'network', networkResponse.clone());
          console.log('[DefaultSW] Background update completed for:', request.url);
        }
      }).catch((err) => {
        console.warn('[DefaultSW] Background update failed for:', request.url, err);
      });

      return cachedResponse;
    }

    try {
      const networkResponse = await fetch(request);
      if (networkResponse && networkResponse.status === 200) {
        cache.put(request, networkResponse.clone());
        const clone = networkResponse.clone();
        notifyClients(request.url, 'network', clone);
      }
      return networkResponse;
    } catch (err) {
      return cachedResponse || new Response('Network error', { status: 408 });
    }
  })());
});

// --------- utility functions ---------

function hashString(str) {
  let hash = 0;
  if (str.length === 0) return hash;
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i);
    hash = ((hash << 5) - hash) + char;
    hash = hash & hash;
  }
  return hash;
}

async function notifyClients(url, updateType, body) {
  try {
    let payload, hash;

    if (body === null || body === undefined) {
      payload = '';
      hash = hashString(payload);
    } else if (body instanceof Response) {
      const contentType = body.headers.get('content-type') || '';

      if (contentType.includes('application/json')) {
        payload = JSON.stringify(await body.json());
      } else if (contentType.includes('text/') || contentType.includes('application/xml')) {
        payload = await body.text();
      } else if (contentType.includes('image/') || contentType.includes('audio/') || contentType.includes('video/')) {
        const arrayBuffer = await body.arrayBuffer();
        const uint8Array = new Uint8Array(arrayBuffer);
        payload = Array.from(uint8Array, byte => String.fromCharCode(byte)).join('');
      } else {
        payload = await body.text();
      }
      hash = hashString(payload);
    } else if (typeof body === 'string') {
      payload = body;
      hash = hashString(payload);
    } else if (typeof body === 'object') {
      if (body instanceof ArrayBuffer) {
        const uint8Array = new Uint8Array(body);
        payload = Array.from(uint8Array, byte => String.fromCharCode(byte)).join('');
      } else if (body instanceof Blob) {
        payload = await body.text();
      } else if (body instanceof FormData) {
        const formDataObj = {};
        for (let [key, value] of body.entries()) {
          formDataObj[key] = value;
        }
        payload = JSON.stringify(formDataObj);
      } else {
        payload = JSON.stringify(body);
      }
      hash = hashString(payload);
    } else {
      payload = String(body);
      hash = hashString(payload);
    }

    const clients = await self.clients.matchAll({ type: "window" });
    clients.forEach(client => {
      client.postMessage({
        type: "RESOURCE_UPDATED",
        url,
        updateType,   // "cache" or "network"
        body: payload,
        hash,
        timestamp: Date.now()
      });
    });
  } catch (error) {
    console.error('[DefaultSW] Error in notifyClients:', error);
    const clients = await self.clients.matchAll({ type: "window" });
    clients.forEach(client => {
      client.postMessage({
        type: "RESOURCE_UPDATED_ERROR",
        url,
        updateType,
        error: error.message,
        timestamp: Date.now()
      });
    });
  }
}
