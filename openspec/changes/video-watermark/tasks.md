## 1. Data Integration & Setup

- [x] 1.1 Extract the `type` and `position` configuration for the watermark from the backend API response.
- [x] 1.2 Retrieve the current user's username to use as the text for the watermark.

## 2. Configuration Mapping

- [x] 2.1 Implement the mapping logic for the `static` type, converting the 5 predefined position strings (top left, top right, bottom left, bottom right, middle) into exact `x` and `y` percentage coordinates for the SDK.
- [x] 2.2 Implement the mapping logic for the `dynamic` type, configuring it to use `WatermarkAnimationType.pingPong` with an appropriate duration.
- [x] 2.3 Handle the `hidden` type logic to ensure no watermark is displayed.

## 3. Player Integration

- [x] 3.1 Construct the `WatermarkConfig` instance using the mapped properties, text, a standard opacity (e.g., 0.5), and a white color code.
- [x] 3.2 Pass the configured list of watermarks to the player SDK via `_controller.setWatermarks()`.
- [x] 3.3 Test and verify that the watermark behaves correctly according to the backend configuration for static, dynamic, and hidden modes.
