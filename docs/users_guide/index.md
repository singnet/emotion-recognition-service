![singnetlogo](../assets/singnet-logo.jpg?raw=true 'SingularityNET')

# Emotion Recognition Service
## Service User's Guide

### Welcome
This service provides emotion recognition service using facial image and landmarks obtained from [dlib](dlib.net) to feed 
a deep neural networks trained in keras/tensorflow.

This service provides the trained model as service for emotion recognition given an image. It returns the bounding boxes of the detected 
faces and the emotion. 

### How does it work?

The user must provide a request satisfying the proto descriptions [given](../../service_spec/EmotionService.proto). That is

* An request with `image_type`: the type of the input image. 
* And the image `image`: the string64 encoded input image.

The following options are available for image type: `png`, `jpg`

The input image can be `monochrome`, `rgb`, `rgba`. Additional values hadn't yet been tested.
### TODO
- We need to move string64 encoding to stream in the proto description to allow much bigger images as input for query. This
would change the test and handling on both the client and server side.

### Using the service on the platform

The returned result has the following form: 
```bash
message RecognizeResponse {
	repeated string predictions = 1; 
	repeated BoundingBox bounding_boxes = 2; 
}
```

An example result obtained after passing the [image](../../turtles.png)
```bash
predictions: "fear"
predictions: "happy"
predictions: "sad"
predictions: "happy"
predictions: "anger"
predictions: "happy"
bounding_boxes {
  x: 572
  y: 112
  w: 104
  h: 103
}
bounding_boxes {
  x: 841
  y: 161
  w: 150
  h: 150
}
bounding_boxes {
  x: 365
  y: 42
  w: 104
  h: 104
}
bounding_boxes {
  x: 411
  y: 286
  w: 124
  h: 125
}
bounding_boxes {
  x: 742
  y: 93
  w: 125
  h: 124
}
bounding_boxes {
  x: 145
  y: 112
  w: 149
  h: 149
}

```

This form isn't expected to change as the input format. 

### TODO
- Exact steps and service registry address would be updated once service had been registered to platform.
