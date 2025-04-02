#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
答案之书应用 - 数据模型初始化

这个模块初始化SQLAlchemy和数据库连接。
"""

from flask_sqlalchemy import SQLAlchemy

# 创建SQLAlchemy实例
db = SQLAlchemy()

# 导入所有模型，确保它们被正确注册
from .user import User
from .category import Category
from .answer import Answer
from .favorite import Favorite
from .history import History

# 初始化数据库
def init_db(app):
    """初始化数据库"""
    db.init_app(app)
    
    # 在应用上下文中创建所有表
    with app.app_context():
        db.create_all()
        
        # 初始化分类数据
        from .category import Category
        categories_data = [
            {'name': '基础', 'description': '基础类型的答案'},
            {'name': '中性', 'description': '中性的答案'},
            {'name': '极端', 'description': '极端的答案'},
            {'name': '思考', 'description': '需要思考的答案'},
            {'name': '行动', 'description': '行动导向的答案'}
        ]
        
        # 检查分类是否已存在
        for cat_data in categories_data:
            if not Category.query.filter_by(name=cat_data['name']).first():
                category = Category(**cat_data)
                db.session.add(category)
        db.session.commit()
        
        # 初始化答案数据
        from .answer import Answer
        answers_data = [
            {'content': '是的', 'category_name': '基础'},
            {'content': '不是', 'category_name': '基础'},
            {'content': '也许吧', 'category_name': '中性'},
            {'content': '再等等看', 'category_name': '中性'},
            {'content': '绝对不行', 'category_name': '极端'},
            {'content': '当然可以', 'category_name': '极端'},
            {'content': '需要更多信息', 'category_name': '思考'},
            {'content': '相信你的直觉', 'category_name': '思考'},
            {'content': '值得一试', 'category_name': '行动'},
            {'content': '不要犹豫', 'category_name': '行动'}
        ]
        
        # 检查答案是否已存在
        for ans_data in answers_data:
            category = Category.query.filter_by(name=ans_data['category_name']).first()
            if category and not Answer.query.filter_by(content=ans_data['content']).first():
                answer = Answer(content=ans_data['content'], category_id=category.id)
                db.session.add(answer)
        db.session.commit()