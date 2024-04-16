# ARKit in visionOS Examples

> [!TIP]
>
> This repository will be continuously updated with new samples. When it has a certain number of samples and Apple Vision Pro is released (it means this repo can have screenshots of the actual devices), I plan to officially release it as "visionOS-Sampler". If you're interested, please star & watch this repository for updates. Related Repositories: [ARKit-Sampler](https://github.com/shu223/ARKit-Sampler) / [iOS-Depth-Sampler](https://github.com/shu223/iOS-Depth-Sampler)

## Requiments

- visionOS 1.0+
- Xcode 15.2+
- Apple Vision Pro

## Contents

### 01_ARKitDataAccess

Implementation as an application based on Apple's tutorial code:

[Setting up access to ARKit data | Apple Developer Documentation](https://developer-apple-com.translate.goog/documentation/visionos/setting-up-access-to-arkit-data)



### 02_ARKitPlacingContent

**Visualization of the planes** detected with `PlaneDetectionProvider`.

![](https://storage.googleapis.com/zenn-user-upload/deployed-images/3298443097ea4fe8db13be15.gif?sha=b626216787695f05c77bd36cbfbfbdb0e72a1ee6)
*From "[Placing content on detected planes](https://developer-apple-com.translate.goog/documentation/visionos/placing-content-on-detected-planes)".  (This is not an actual screen capture of this sample.)*

Blog (Japanese): [[visionOS] ARKitで検出した平面を可視化する](https://zenn.dev/shu223/articles/visionos_planedetection)

### 03_ARKitSceneReconstruction

**Visualization of the mesh of the scene** detected with `SceneReconstructionProvider`.

Blog (Japanese):  [[visionOS] ARKitで検出したシーンのメッシュを可視化する](https://zenn.dev/shu223/articles/visionos_scenemesh)



### 04_ARKitHandTracking

**Visualization of the joints in hands** detected with `HandTrackingProvider`.

![](https://res.cloudinary.com/zenn/image/fetch/s--UbavivFk--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_1200/https://storage.googleapis.com/zenn-user-upload/deployed-images/4219e1557601d5812341448e.png%3Fsha%3D3eb90990d08ada824a7a7226bfd68f2caceaa293)

