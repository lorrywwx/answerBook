#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
答案之书应用 - 用户模型

这个模块定义了用户数据模型。
"""

from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash
from . import db


class User(db.Model):
    """用户模型"""
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(50), nullable=False, comment='用户名')
    email = db.Column(db.String(100), unique=True, nullable=False, comment='电子邮箱')
    password_hash = db.Column(db.String(128), nullable=False, comment='密码哈希值')
    created_at = db.Column(db.DateTime, default=datetime.now, comment='创建时间')
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')
    last_login = db.Column(db.DateTime, nullable=True, comment='最后登录时间')
    is_active = db.Column(db.Boolean, default=True, comment='是否激活')
    
    # 关联收藏
    favorites = db.relationship('Favorite', backref='user', lazy='dynamic', cascade='all, delete-orphan')
    # 关联历史记录
    history = db.relationship('History', backref='user', lazy='dynamic', cascade='all, delete-orphan')
    
    @property
    def password(self):
        """密码属性不可读"""
        raise AttributeError('密码不可读')
    
    @password.setter
    def password(self, password):
        """设置密码，自动生成哈希值"""
        self.password_hash = generate_password_hash(password)
    
    def verify_password(self, password):
        """验证密码"""
        return check_password_hash(self.password_hash, password)
    
    def __repr__(self):
        return f'<User: {self.username}({self.email})>'
    
    def to_dict(self):
        """将模型转换为字典"""
        return {
            'id': self.id,
            'username': self.username,
            'email': self.email,
            'created_at': self.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            'updated_at': self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
            'last_login': self.last_login.strftime('%Y-%m-%d %H:%M:%S') if self.last_login else None,
            'is_active': self.is_active
        }