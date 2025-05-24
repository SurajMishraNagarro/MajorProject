"""
Flask application factory function with Prometheus instrumentation.

This module initializes the Flask app and its extensions, including:
- SQLAlchemy for database management.
- Flask-Login for user authentication.
- CSRF protection via Flask-WTF.
- Flask-Migrate for handling database migrations.
- Environment variable loading with dotenv.
- PrometheusMetrics for application monitoring.

Functions:
- `create_app()`: Initializes and returns a Flask application instance with Prometheus metrics.
"""
from flask_sqlalchemy import SQLAlchemy
from flask import Flask
from flask_login import LoginManager
from flask_wtf import CSRFProtect
from flask_migrate import Migrate
from dotenv import load_dotenv
import os
from prometheus_flask_exporter import PrometheusMetrics

# Initialize extensions
db = SQLAlchemy()
login_manager = LoginManager()
csrf = CSRFProtect()


def create_app():
    # Load environment variables
    load_dotenv()

    app = Flask(__name__)
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SECRET_KEY'] = "jkokdowkjojwojd183hb8d383b"
    app.config['TEMPLATES_AUTO_RELOAD'] = True

    # Initialize Flask extensions
    db.init_app(app)
    login_manager.init_app(app)
    csrf.init_app(app)
    Migrate(app, db)
    login_manager.login_view = 'auth.login'

    # Register blueprints
    from app.routes import main
    from app.auth import auth
    app.register_blueprint(main)
    app.register_blueprint(auth)

    # Create database tables
    with app.app_context():
        db.create_all()

   # Expose /metrics with default HTTP metrics (request count, latencies, etc.)
    # Explicitly set the path for metrics endpoint
    metrics = PrometheusMetrics(app, path='/metrics')
    
    # Make sure metrics are initialized
    metrics.info('app_info', 'Application info', version='1.0.0')

    return app