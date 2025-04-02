# 答案之书应用 - API文档

## 基础信息

- 基础URL: `http://localhost:5000/api`
- 所有请求和响应均使用JSON格式
- 认证方式: JWT Token (在请求头中添加 `Authorization: Bearer <token>`)

## 状态码

| 状态码 | 描述 |
|--------|------|
| 200 | 成功 |
| 201 | 创建成功 |
| 400 | 请求参数错误 |
| 401 | 未授权 |
| 403 | 禁止访问 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

## API接口

### 用户相关

#### 注册用户

- **URL**: `/auth/register`
- **方法**: `POST`
- **描述**: 注册新用户
- **请求参数**:

```json
{
  "username": "string",
  "email": "string",
  "password": "string"
}
```

- **响应**:

```json
{
  "code": 201,
  "message": "注册成功",
  "data": {
    "user_id": "integer",
    "username": "string",
    "email": "string",
    "created_at": "string"
  }
}
```

#### 用户登录

- **URL**: `/auth/login`
- **方法**: `POST`
- **描述**: 用户登录
- **请求参数**:

```json
{
  "email": "string",
  "password": "string"
}
```

- **响应**:

```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "token": "string",
    "user": {
      "user_id": "integer",
      "username": "string",
      "email": "string"
    }
  }
}
```

### 答案相关

#### 获取随机答案

- **URL**: `/answers/random`
- **方法**: `GET`
- **描述**: 获取随机答案
- **请求参数**: 无
- **响应**:

```json
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "answer": {
      "id": "integer",
      "content": "string",
      "category_id": "integer",
      "category_name": "string"
    }
  }
}
```

#### 获取答案分类列表

- **URL**: `/categories`
- **方法**: `GET`
- **描述**: 获取所有答案分类
- **请求参数**: 无
- **响应**:

```json
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "categories": [
      {
        "id": "integer",
        "name": "string",
        "description": "string"
      }
    ]
  }
}
```

#### 按分类获取随机答案

- **URL**: `/answers/random/{category_id}`
- **方法**: `GET`
- **描述**: 获取指定分类的随机答案
- **请求参数**: 无
- **响应**:

```json
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "answer": {
      "id": "integer",
      "content": "string",
      "category_id": "integer",
      "category_name": "string"
    }
  }
}
```

### 收藏相关

#### 收藏答案

- **URL**: `/favorites`
- **方法**: `POST`
- **描述**: 收藏一个答案
- **请求参数**:

```json
{
  "answer_id": "integer"
}
```

- **响应**:

```json
{
  "code": 201,
  "message": "收藏成功",
  "data": {
    "favorite_id": "integer",
    "user_id": "integer",
    "answer_id": "integer",
    "created_at": "string"
  }
}
```

#### 获取收藏列表

- **URL**: `/favorites`
- **方法**: `GET`
- **描述**: 获取当前用户的收藏列表
- **请求参数**: 无
- **响应**:

```json
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "favorites": [
      {
        "id": "integer",
        "user_id": "integer",
        "answer_id": "integer",
        "created_at": "string",
        "answer": {
          "id": "integer",
          "content": "string",
          "category_id": "integer",
          "category_name": "string"
        }
      }
    ]
  }
}
```

#### 取消收藏

- **URL**: `/favorites/{favorite_id}`
- **方法**: `DELETE`
- **描述**: 取消收藏
- **请求参数**: 无
- **响应**:

```json
{
  "code": 200,
  "message": "取消收藏成功",
  "data": null
}
```

## 错误响应格式

```json
{
  "code": "integer",
  "message": "string",
  "errors": [
    {
      "field": "string",
      "message": "string"
    }
  ]
}
```