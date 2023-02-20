
参考链接：https://www.jianshu.com/p/2761f661ca89

## AVFoundation框架用途：
    音频的录制、播放，视频的播放，媒体文件检查，媒体捕捉，媒体编辑，媒体处理，媒体采样，媒体压缩，音频编解码，视频编解码，音频的音效处理
    
## 视频流处理
    AVCaptureDevice 代表了输入设备,例如摄像头与麦克风。
    AVCaptureInput  代表了输入数据源
    AVCaptureOutput 代表了输出数据源
    AVCaptureSession    用于协调输入与输出之间的数据流

## AVFoundation框架的主要类和功能
    AVAnimation 动画类
    AVAsset 资产类可通过这个类获得图片、文件、媒体库
            一个AVAsset对象是一个或多个媒体数据（音频和视频轨道）的集合的聚合表示(抽象类)。它提供关于整个集合的信息，例如其标题，持续时间，自然呈现大小等。
            AVAsset不受特定数据格式的限制。它是其他类的超类，用于从URL中的媒体创建资产实例并创建新组合。资产中的每个媒体数据片段都是统一的类型，称为轨道。
            资产的呈现状态由播放器项目对象管理， 资源内的每个轨道的呈现状态由播放器项目轨道对象管理。
            AVAsset是由AVAssetTrack(音频、视频、字幕三个轨道)的一个或多个实例组成的容器对象，它对资产的均匀类型的媒体流进行建模。 
            使用其轨道属性检索资源的轨道集合。 在许多情况下，您将需要对资产轨道的子集合执行操作，而不是对其完整集合执行操作。
            创建资源不会自动加载其属性或为任何特定用途做准备。相反，资产的属性值的加载被推迟到被请求为止。 因为属性访问是同步的，如果以前没有加载请求的属性， 则框架可能需要执行大量的工作才能返回值。
            AVAsset和AVAssetTrack采用AVAsynchronousKeyValueLoading协议，它定义了用于查询属性的当前加载状态的方法，并根据需要异步加载一个或多个属性值。

    AssetDownloadTask   资源下载任务
    AVAssetExportSession    资源导出会话:是一个通过资源文件对象去创建一个指定预设的输出的转码内容会话
    AVAssetImageGenerator   用于截取视频某帧的画面
    AVAssetReader   从资源读取音视频数据
    AVAssetReaderOutput 读取资源文件输出类
    AVAssetResourceLoader   资源文件的加载器会从AVURLAsset和代理方法得到加载的内容
    AVAssetTrack    资源的分轨
    AVAssetTrackGroup   这里面封装了一组资源的分轨
    AVAssetTrackSegment 表示资源分轨的一段
    AVAssetWriter   资源文件写入类
    AVAssetWriterInput  写入文件的输入类
    AVAssetDownloadTask 资源文件下载任务
    AVCaptureDevice 硬件捕获设备类
    AVCaptureInput  从硬件捕获设备获得输入的数据
    AVCaptureOutput 获得输出的数据
    AVCaptureSession    用于调配音视频输入与输出之间的数据流
    AVCaptureVideoPreviewLayer  捕获的视频数据的预览图层
    AVMetadataObject    音视频元数据是一个基类里面包含面部检测的元数据和二维码的元数据
    AVPlayer    音视频播放器
    AVPlayerItem    音视频播放的元素
    AVPlayerItemMediaDataCollector  音视频播放器元素媒体数据收集器
    AVPlayerItemOutput  播放器元素输出类
    AVPlayerItemTrack   播放器元素的分轨
    AVPlayerLayer   播放器的图层
                AVPlayerLayer不提供任何播放控件，而只显示播放器的视觉内容。 建立播放传输控制来播放，暂停和seek媒体是由你决定的。
                
    AVPlayerMediaSelectionCriteria  播放器媒体选择的规范
    AVSampleBufferDisplayLayer  用来显示压缩或解压的视频帧
    AVSynchronizedLayer 同步动画图层
    AVTextStyleRule 文本样式的规范
    AVVideoCompositing  视频合成的协议
    AVAudioSettings 音频的配置信息
    AVAudioEngine 音频引擎
    AVAudioNode 音频节点
    AVAudioTime 音频时间类
    AVMIDIPlayer    MIDI播放器
    AVAudioSession  音频会话
        用于设置当前的音频场景，例如 audioSession.setCategory(AVAudioSessionCategoryPlayback)
        当App激活Session的时候，是否会打断其他不支持混音的App声音、当用户触发手机上的“静音”键时或者锁屏时，是否相应静音、是否支持录音、是否支持播放
    




