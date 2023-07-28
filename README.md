# LAVA-M Docker

LAVA-M是一个非常经典的模糊测试数据集，具体可见论文[LAVA: Large-Scale Automated Vulnerability Addition](https://ieeexplore.ieee.org/document/7546498)。

由于其发表的时间非常早，目前已经无法在Ubuntu的较新版本中运行。因此，我参考了[Ubuntu21.04安装LAVA-M数据集并使用AFL测试](http://t.csdn.cn/rCg2J)等文章，编写了一个Dockerfile，方便在目前最新的ubuntu 22.04上编译可用的LAVA-M测试集。

## 使用方法

```shell
git clone --depth 1 https://github.com/Evian-Zhang/lava-m-docker && cd lava-m-docker
docker build -t lava-m-docker:latest --build-arg MY_USERNAME=xxxx . 
```

值得注意的是，由于LAVA-M的编译脚本必须由非root用户执行，因此需要指定一个非root用户，这里是通过`--build-arg MY_USERNAME=xxxx`实现的，其中"xxxx"可以填任意用户名。

在生成的docker镜像中，所有程序都位于`/home/xxxx/lava_corpus`目录下。
