"""
Form Definitions for User Authentication and Todo Management.

This module defines Flask-WTF forms for handling user authentication 
(login, signup) and Todo item creation and updates.

Classes
-------
- `LoginForm` : Handles user login.
- `SignupForm` : Handles user registration.
- `TodoForm` : Allows users to create a new Todo item.
- `UpdateTodoForm` : Allows users to update an existing Todo item.

Dependencies
------------
- `FlaskForm` from Flask-WTF for form handling.
- `wtforms` for defining form fields and validation.
- `flask_login` for user session management.
- `Todo` model for managing Todo items.

"""

from flask_wtf import FlaskForm
from wtforms import StringField,PasswordField,SubmitField,DateTimeField
from flask_login import login_required,current_user
from wtforms.validators import DataRequired,Length
from .models import Todo

class LoginForm(FlaskForm):
    """
    Form for user login.

    Fields:
    -------
    - `user_name` : Username field (Required).
    - `password` : Password field (Required).
    - `submit` : Login button.
    """

    user_name=StringField("Username",validators=[DataRequired()])
    password=PasswordField("Password",validators=[DataRequired()])
    submit=SubmitField("Login")

class SignupForm(FlaskForm):
    """
    Form for new user registration.

    Fields:
    -------
    - `first_name` : First name (Required).
    - `middle_name` : Middle name (Optional, defaults to empty string).
    - `last_name` : Last name (Optional, defaults to empty string).
    - `user_name` : Username (Required, must be 3-40 characters long).
    - `password` : Password field (Required).
    - `submit` : Sign-up button.
    """

    first_name = StringField("First Name", validators=[DataRequired()])
    middle_name = StringField("Middle Name", default='')
    last_name = StringField("Last Name", default='')
    user_name = StringField("Username", validators=[DataRequired(), Length(min=3, max=40)])
    password = PasswordField("Password", validators=[DataRequired()])
    submit = SubmitField("Sign Up")

class TodoForm(FlaskForm):
    """
    Form for creating a new Todo item.

    Fields:
    -------
    - `title` : Title of the task (Required).
    - `due_time` : Due date as a string (Required).
    - `submit` : Submit button.
    """

    title=StringField("Title",validators=[DataRequired()])
    due_time=StringField("Due Date",validators=[DataRequired()])
    submit = SubmitField("Submit")

class UpdateTodoForm(FlaskForm):
    """
    Form for updating an existing Todo item.

    Fields:
    -------
    - `title` : Updated title of the task (Required).
    - `due_time` : Updated due date as a string (Optional).
    - `submit` : Submit button.
    """

    title=StringField("Title",validators=[DataRequired()])
    due_time=StringField("Due Date")
    submit = SubmitField("Submit")
