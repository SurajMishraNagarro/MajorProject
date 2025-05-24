"""
Flask application entry point with Prometheus metrics setup.

This module runs the Flask application created by the factory function
and sets up Prometheus metrics exposure.
"""
from app import create_app
from prometheus_client import make_wsgi_app
from werkzeug.middleware.dispatcher import DispatcherMiddleware
from werkzeug.serving import run_simple

# Create the Flask application
app = create_app()

# Add Prometheus middleware to ensure metrics are available at /metrics
# This creates a dispatcher that will route /metrics requests to the Prometheus WSGI app
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
    '/metrics': make_wsgi_app()
})

if __name__ == "__main__":
    with app.app_context():
        # Run the application
        app.run(host='0.0.0.0', port=9090, debug=True)