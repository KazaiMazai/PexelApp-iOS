# PexelAPP-iOS

This is demo app using the Pexels photos API

## Features
- Main Feed
- Interactive Photo Detail View
- Image Caching

## Setup

1. Clone the repo:

```
git clone https://github.com/KazaiMazai/PexelApp-iOS.git
```
 
2. On the first build, an `env.xcconfig` file will be created in 
```
PexelApp-iOS/Configuration/EnvironmentVars/env.xcconfig
``` 
Put your Pexels API key in this file. 
This file is ignored by git, so your API key is safe.

3. Add `env.xcconfig` to Xcode (optional but recommended):
   - Open Xcode.
   - Go to File -> Add Files to ....
   - Add the `env.xcconfig` file to your project.

4. Build again. Navigate to 
```
PexelApp-iOS/Configuration/EnvironmentVars/EnvironmentVars.generated.swift
```
and ensure your API key is properly injected. This file is ignoted by git, keeping your API key secure.

6. Now you can run the app and enjoy the photos.


