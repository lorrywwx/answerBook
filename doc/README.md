# 答案之书应用

## 项目概述

答案之书是一个简单而有趣的应用，用户打开应用后会看到一本虚拟的书，通过翻书动画效果可以获取随机的答案。应用采用Flutter开发前端UI，后端使用Python+Flask+MySQL提供服务支持。

## 目录结构

```
/
├── doc/                    # 文档目录
│   ├── README.md           # 项目说明文档
│   ├── development.md      # 开发进度文档
│   ├── api.md              # API文档
│   └── data_dictionary.md  # 数据字典文档
├── frontend/               # Flutter前端应用
│   ├── lib/                # Flutter源代码
│   ├── assets/             # 静态资源（图片、字体等）
│   └── pubspec.yaml        # Flutter依赖配置
└── backend/                # Python后端服务
    ├── app.py              # Flask应用入口
    ├── config.py           # 配置文件
    ├── models/             # 数据模型
    ├── routes/             # API路由
    ├── services/           # 业务逻辑
    ├── utils/              # 工具函数
    ├── requirements.txt    # Python依赖
    └── environment.yml     # Anaconda环境配置
```

## 技术选型

### 前端
- **Flutter**: 跨平台UI框架，用于构建高性能、高保真的应用
- **Material Design**: UI设计风格，提供现代化的用户界面
- **Provider/Bloc**: 状态管理
- **Dio**: 网络请求

### 后端
- **Python**: 编程语言
- **Anaconda**: 虚拟环境管理
- **Flask**: Web框架
- **SQLAlchemy**: ORM框架
- **MySQL**: 数据库
- **JWT**: 用户认证

## 启动命令

### 后端启动

1. 创建并激活Anaconda环境
```bash
conda env create -f environment.yml
conda activate answer_book
```

2. 启动Flask服务
```bash
cd backend
python app.py
```

### 前端启动

1. 安装依赖
```bash
cd frontend
flutter pub get
```

2. 运行应用
```bash
flutter run
flutter run -d edge
```

## 功能特性

- 精美的书本UI设计
- 流畅的翻书动画效果
- 随机生成有趣的答案
- 答案收藏功能
- 历史记录查看

## 开发团队

- 开发者：[您的名字]

## 版本历史

- v0.1.0 - 初始项目框架搭建