![singnetlogo](docs/assets/singnet-logo.jpg?raw=true 'SingularityNET')

[![CircleCI](https://circleci.com/gh/tesYolan/emotion-recognition-service/tree/master.svg?style=svg)](https://circleci.com/gh/tesYolan/emotion-recognition-service/tree/master)
# Emotion recognition from face features
This project is aimed to train model that detects emotion from face image.
## Install prerequisites
### Using conda
```
# with conda
conda env update
# to activate environment
conda activate emotion-recogntion-snet-agent
```
### Using pip
```
# to utilize pip
pip install -r requirements.txt
```
Or if you have GPU
```bash
pip install -r requirement-gpu.txt
```

#### Getting the models
After you have setted up the repository, one can get the models for landmark detection by invoking the following command
Also the following script pulls in the [snet-daemon](https://github.com/singnet/snet-daemon/releases/tag/v0.1.3). 
```bash
# Download the snet daemon and dlib shapekey model. 
./install.sh
```
### Using docker with GPU
If you have a [nvidia-docker2](https://github.com/NVIDIA/nvidia-docker.git) installed, we have Dockerfile.gpu which you
can use to build your image. 
```
docker build --file Dockerfile.gpu . -t singnet:emopy
```
### Using docker with CPU
You can also build an image which has only the CPU dependecies to evaluate the models provided. 
```bash
docker build --file Dockerfile . -t singnet:emopy-cpu
```

#### How to Use the docker image
We have two ports exposed in our configuraiton for both containers: 6205 and 8001 for the snet-daemon and grpc endpoint. 
To run with grpc endpoint available one can call: 
```bash
# This starts the grpc endpoint alone.
docker run -it --rm -P 8001:8001 emotion-recongition:latest python3.6 script.py

# To run with the daemon only exposed. We have a command at the end of the Dockerfile to execute it. 
docker run -it --rm -P 6205:6205 emotion-recongition:latest 

```
## How to preprocess datasets
This proejct uses [CK+ dataset](http://www.consortium.ri.cmu.edu/ckagree/) and  [Kaggle fer2013 dataset](https://www.kaggle.com/c/challenges-in-representation-learning-facial-expression-recognition-challenge/data).  
The dataset should be saved inside single directory which contains ```train``` and ```test``` folders.
* To extract kaggle's dataset follow the instruction to download the dataset [here](https://www.kaggle.com/c/challenges-in-representation-learning-facial-expression-recognition-challenge/data) 
  * Extract the dataset 
  * Inside this projects directory run the following code on terminal
```
python -m preprocess_fer -d /path-to-fer2013.csv-extracted 
```
* To process the ck+ dataset go to [this repository](https://github.com/mitiku1/Ck-dataset-preprocess)
* After preprocessing both dataset merge the two datasets mannually



### How to run training program
The four inputs model can be trained by three steps
* **shape_predictor should be inside root directory of this project. Shape predictor can be downloaded to project using the following script.**
```
cd /path-to-project
wget "http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2"
bzip2 -d shape_predictor_68_face_landmarks.dat.bz2
```
Training program can be run using the following command
```
python -m train [options]
```
Option to train program are
  * -d : Dataset directory path that contains train and test folders
  * -e : Number of epochs to train the model
  * -b : Training batch size
  * -s : Steps per epoch
  * -f : This option specifies the type of model to train. the options can be 'image', 'dlib' or 'all'. The default is 'all'. If user enters option that is not from ('image', 'dlib', 'all') then program continues with default option. Before training the 'all' model type the other two models should be trained and saved inside 'logs/models/' folder.
  * -l : learning rate
  * -i : image input shape


#### Step 1 - Training image input model
``` 
python -m train [options] -f image 
```
#### Step 3 - Training dlib features input model
``` 
python -m train [options] -f dlib 
```
#### Step 3 - Training the main model
``` 
python -m train [options] 
```

### Running Demo program
``` 
python -m demo [options]
```  
Options for demo program are
* -j : model json file
* -w : model weights
* -i : Face image source. This could be either `image`, `video` or `webcam`. Defualt is webcam.
* -p : Path to source file. If options -i is webcam this is not necessary.

### Using as singularitynet service
Trained models are available to be run as services to provide emotional results for image currently. It's based on the (alpha-service-example)[https://github.com/singnet/alpha-service-example]. And thus most of the parts are similar. 
```
cp snet.config.example snet.config 
# add private key on snet.config
  `"PRIVATE_KEY": "#PRIVATEKEY GOES HERE"`
python run-snet-service.py --daemon-config-path snet.config

# to test
python test_rpc_call.py
```
### Accessing on Daap
Go to http://alpha.singularitynet.io/ to create a job

#### TODO
* Better data responses to queries. As it stands we just serialize the data as string. But it's better to utilize grpcs to have consistent message format to communicate with other services or just for single user. 

# Authors
- Mitiku Yohannes - Author - [SingularityNet.io](https://singularitynet.io)
- Tesfa Yohannes - Maintainer - [SingularityNet.io](https://singularitynet.io)

 sp: http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2
