# 答案之书应用 - 数据字典

## 数据库设计

数据库名称：`answer_book`

### 表结构

#### 1. 用户表 (users)

| 字段名 | 类型 | 长度 | 允许空 | 主键 | 默认值 | 说明 |
|--------|------|------|--------|------|--------|------|
| id | INT | - | 否 | 是 | 自增 | 用户ID |
| username | VARCHAR | 50 | 否 | 否 | - | 用户名 |
| email | VARCHAR | 100 | 否 | 否 | - | 电子邮箱 |
| password_hash | VARCHAR | 128 | 否 | 否 | - | 密码哈希值 |
| created_at | DATETIME | - | 否 | 否 | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | 否 | 否 | CURRENT_TIMESTAMP | 更新时间 |
| last_login | DATETIME | - | 是 | 否 | NULL | 最后登录时间 |
| is_active | TINYINT | 1 | 否 | 否 | 1 | 是否激活 |

**索引**：
- 主键：`id`
- 唯一索引：`email`

#### 2. 答案分类表 (categories)

| 字段名 | 类型 | 长度 | 允许空 | 主键 | 默认值 | 说明 |
|--------|------|------|--------|------|--------|------|
| id | INT | - | 否 | 是 | 自增 | 分类ID |
| name | VARCHAR | 50 | 否 | 否 | - | 分类名称 |
| description | VARCHAR | 200 | 是 | 否 | NULL | 分类描述 |
| created_at | DATETIME | - | 否 | 否 | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | 否 | 否 | CURRENT_TIMESTAMP | 更新时间 |
| is_active | TINYINT | 1 | 否 | 否 | 1 | 是否激活 |

**索引**：
- 主键：`id`
- 唯一索引：`name`

#### 3. 答案表 (answers)

| 字段名 | 类型 | 长度 | 允许空 | 主键 | 默认值 | 说明 |
|--------|------|------|--------|------|--------|------|
| id | INT | - | 否 | 是 | 自增 | 答案ID |
| content | VARCHAR | 500 | 否 | 否 | - | 答案内容 |
| category_id | INT | - | 是 | 否 | NULL | 分类ID |
| created_at | DATETIME | - | 否 | 否 | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | DATETIME | - | 否 | 否 | CURRENT_TIMESTAMP | 更新时间 |
| is_active | TINYINT | 1 | 否 | 否 | 1 | 是否激活 |

**索引**：
- 主键：`id`
- 外键：`category_id` 引用 `categories(id)`

#### 4. 收藏表 (favorites)

| 字段名 | 类型 | 长度 | 允许空 | 主键 | 默认值 | 说明 |
|--------|------|------|--------|------|--------|------|
| id | INT | - | 否 | 是 | 自增 | 收藏ID |
| user_id | INT | - | 否 | 否 | - | 用户ID |
| answer_id | INT | - | 否 | 否 | - | 答案ID |
| created_at | DATETIME | - | 否 | 否 | CURRENT_TIMESTAMP | 创建时间 |

**索引**：
- 主键：`id`
- 外键：`user_id` 引用 `users(id)`
- 外键：`answer_id` 引用 `answers(id)`
- 唯一索引：`user_id, answer_id` (确保用户不会重复收藏同一个答案)

#### 5. 历史记录表 (history)

| 字段名 | 类型 | 长度 | 允许空 | 主键 | 默认值 | 说明 |
|--------|------|------|--------|------|--------|------|
| id | INT | - | 否 | 是 | 自增 | 历史记录ID |
| user_id | INT | - | 否 | 否 | - | 用户ID |
| answer_id | INT | - | 否 | 否 | - | 答案ID |
| created_at | DATETIME | - | 否 | 否 | CURRENT_TIMESTAMP | 创建时间 |

**索引**：
- 主键：`id`
- 外键：`user_id` 引用 `users(id)`
- 外键：`answer_id` 引用 `answers(id)`
- 索引：`user_id, created_at` (用于快速查询用户的历史记录)

## 关系图

```
+--------+       +-----------+       +---------+
| users  |------>| favorites |<------| answers |
+--------+       +-----------+       +---------+
    |                                     ^
    |                                     |
    v                                     |
+---------+                         +------------+
| history |------------------------>| categories |
+---------+                         +------------+
```

## 数据示例

### 用户表示例数据

```sql
INSERT INTO users (username, email, password_hash) VALUES
('user1', 'user1@example.com', 'hashed_password_1'),
('user2', 'user2@example.com', 'hashed_password_2');
```

### 分类表示例数据

```sql
INSERT INTO categories (name, description) VALUES
('生活', '日常生活相关的答案'),
('工作', '职场工作相关的答案'),
('学习', '学习教育相关的答案'),
('爱情', '爱情关系相关的答案'),
('健康', '健康养生相关的答案');
```

### 答案表示例数据

```sql
INSERT INTO answers (content, category_id) VALUES
('是的，现在是最好的时机。', 1),
('不要犹豫，大胆尝试。', 2),
('再等等，时机还不成熟。', 1),
('相信自己的直觉。', 3),
('寻求他人的建议可能会有帮助。', 4),
('改变策略可能会带来不同的结果。', 2),
('坚持下去，成功就在前方。', 3),
('是时候休息一下了。', 5),
('不要害怕失败，它是成功的一部分。', 2),
('这个决定只有你自己能做。', 1);
```