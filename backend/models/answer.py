#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
答案之书应用 - 答案模型

这个模块定义了答案数据模型。
"""

from datetime import datetime
from . import db


class Answer(db.Model):
    """答案模型"""
    __tablename__ = 'answers'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    content = db.Column(db.String(500), nullable=False, comment='答案内容')
    category_id = db.Column(db.Integer, db.ForeignKey('categories.id'), nullable=True, comment='分类ID')
    created_at = db.Column(db.DateTime, default=datetime.now, comment='创建时间')
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')
    is_active = db.Column(db.Boolean, default=True, comment='是否激活')
    
    # 关联分类
    category = db.relationship('Category', backref=db.backref('answers', lazy='dynamic'))
    
    def __repr__(self):
        return f'<Answer: {self.content[:20]}...>'
    
    def to_dict(self):
        """将模型转换为字典"""
        return {
            'id': self.id,
            'content': self.content,
            'category_id': self.category_id,
            'category_name': self.category.name if self.category else None,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
            'is_active': self.is_active
        }
    
    @classmethod
    def get_random(cls):
        """获取随机答案"""
        from sqlalchemy.sql.expression import func
        
        # 使用数据库的随机排序功能获取一个随机答案
        answer = cls.query.filter_by(is_active=True).order_by(func.random()).first()
        return answer