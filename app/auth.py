"""
Authentication and Authorization Routes.

This module defines authentication-related routes for user management, 
including login, signup, logout, and username availability checking.

Blueprint
---------
auth : Flask Blueprint
    Manages authentication and authorization functionalities such as 
    user login, signup, logout, and database interactions.

Routes
------
- `/signup` (GET, POST) : Handles user registration.
- `/check_user_name` (POST) : Checks if a username already exists in the database.
- `/login` (GET, POST) : Authenticates users and handles login attempts.
- `/logout` (GET) : Logs out the current user and redirects to login.
- `/delete_users` (GET) : Deletes all users and associated todos (for admin use).

Dependencies
------------
- Flask, Flask-Login, Flask-SQLAlchemy, Flask-WTF
- Werkzeug for password hashing
- `User` and `Todo` models for database interactions
- `LoginForm` and `SignupForm` for form validation

Security
--------
- Passwords are securely hashed using `pbkdf2:sha256`.
- CSRF protection is enabled via Flask-WTF.
- Login required for logout to prevent unauthorized access.

WARNING
-------
The `/delete_users` route permanently removes all users and todos from the database.
Use it with caution.
"""

from flask import render_template, redirect, url_for, request, flash, Blueprint, jsonify
from .models import User, db, Todo
from .forms import LoginForm, SignupForm
from flask_login import login_user, logout_user, login_required
from werkzeug.security import generate_password_hash, check_password_hash
from prometheus_client import Counter

# Define Blueprint for authentication routes
auth = Blueprint("auth", __name__)

# Prometheus Counters
user_signups_total = Counter('user_signups_total', 'Total number of user signups')
user_logins_success_total = Counter('user_logins_success_total', 'Total number of successful login attempts')
user_logins_failure_total = Counter('user_logins_failure_total', 'Total number of failed login attempts')
user_logouts_total = Counter('user_logouts_total', 'Total number of user logouts')
user_deletions_total = Counter('user_deletions_total', 'Total number of user deletions (via /delete_users)')

@auth.route("/signup", methods=['POST', 'GET'])
def signup():
    """
    Handles user registration.
    - GET: Renders the signup form.
    - POST: Validates form data and creates a new user in the database.

    Returns:
        - Renders signup template on GET request.
        - Redirects to login page on successful registration.
        - Returns 'not validated' message if form validation fails.
    """
    form = SignupForm()
    if request.method == 'GET':
        return render_template("signup.html", form=form)
    
    if form.validate_on_submit():
        first_name = form.first_name.data
        middle_name = form.middle_name.data
        last_name = form.last_name.data
        user_name = form.user_name.data
        password = form.password.data
        hashed_password = generate_password_hash(password, method='pbkdf2:sha256')
        
        user = User(
            first_name=first_name,
            middle_name=middle_name,
            last_name=last_name,
            user_name=user_name,
            password=hashed_password,
            success=0,
            failure=0,
            pending=0
        )
        
        db.session.add(user)
        db.session.commit()
        
        # Increment signup counter
        user_signups_total.inc()

        flash("Account created successfully!", "success")
        return redirect(url_for("auth.login"))
    
    return "not validated"

@auth.route("/check_user_name", methods=['POST'])
def check_user_name():
    """
    Checks if a given username already exists in the database in realtime.

    Returns:
        - JSON response indicating whether the username exists.
        - Error responses if the request is invalid or encounters a server error.
    """
    if request.method == 'POST':
        try:
            data = request.get_json()
            if not data or 'userName' not in data:
                return jsonify({"error": "Invalid request, missing 'userName'"}), 400

            user_name = data['userName']
            user_exists = User.query.filter(User.user_name == user_name).first() is not None
            return jsonify({'exists': user_exists})

        except Exception as e:
            print(f"Error: {str(e)}")
            return jsonify({"error": "Server error"}), 500

@auth.route("/login", methods=['POST', 'GET'])
def login():
    """
    Handles user login.
    - GET: Renders the login form.
    - POST: Validates user credentials and logs them in.

    Returns:
        - JSON response for API login attempts (valid or invalid credentials).
        - Renders login template for GET requests.
    """
    form = LoginForm()
    if request.method == "POST":
        try:
            data = request.get_json()
            if not data:
                return jsonify({"error": "Invalid request, missing 'user_name' or 'password'"}), 400

            user_name = data.get('user_name')
            password = data.get('password')
            user = User.query.filter(User.user_name == user_name).first()

            if user and check_password_hash(user.password, password):
                login_user(user)
                # Increment successful login counter
                user_logins_success_total.inc()
                return jsonify({"valid": True, "redirect": "list"})
            else:
                # Increment failed login counter
                user_logins_failure_total.inc()
                return jsonify({"valid": False, "redirect": "login"})
        except Exception as e:
            print(f"Error: {str(e)}")
            return jsonify({"error": "Server error"}), 500

    return render_template("login.html", form=form)

@auth.route("/logout")
@login_required
def logout():
    """
    Logs out the currently authenticated user.
    
    Returns:
        Redirects to the login page after logging out.
    """
    # Increment logout counter
    user_logouts_total.inc()
    logout_user()
    return redirect(url_for("auth.login"))

@auth.route("/delete_users")
def delete_users():
    """
    Deletes all users and associated todo records from the database.

    WARNING: This will remove all user data and todos permanently.
    Used only for development period.

    Returns:
        A simple HTML response confirming deletion.
    """
    # Increment user deletion counter
    user_deletions_total.inc()
    db.session.query(Todo).delete()
    db.session.query(User).delete()
    db.session.commit()
    return "<h1> Deleted all users </h1>"
