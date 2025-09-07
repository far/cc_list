This was a test task to build Flutter app from this [Figma design prototype](https://www.figma.com/design/W9r6y2DnZvkwCNhsVM1TDx/Untitled--Copy-) with [CoinCap API](https://pro.coincap.io/api-docs) data.

## Demo available [here](https://siamgames.dev/coincap/)

## Installation process:

### 🔑 Set API key to .env file 
```bash
% echo "COINCAP_KEY=<your API KEY>" > .env
```

### 📦 Get deps 
```bash
% flutter pub get
```

### 🤖 Generate code 
```bash
% dart run build_runner build -d
```

### 🚀 Run the app 
```bash
% flutter run ...
```
