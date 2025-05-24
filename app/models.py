"""
Defines Models used in the app

Models :
---------
User : User Model for Authentication and Authorization
Todo : Stores and Manages Todo tasks
"""

from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from . import login_manager,db
from sqlalchemy import event
from datetime import datetime,timedelta
from sqlalchemy.orm import validates
import re


class User(UserMixin,db.Model):
    """
    User Model for Authentication and Authorization

    Attributes:
    ----------
    id : int
        Primary key for the User table.
    
    user_name : str
        Unique username used for login (equivalent to an email). 
        - Must be between 5 and 40 characters.

    first_name : str
        First name of the user.
        - Must be between 2 and 20 characters.

    middle_name : str (Optional)
        Middle name of the user.
        - Default is an empty string.
        - Must be between 2 and 20 characters if provided.

    last_name : str (Optional)
        Last name of the user.
        - Default is an empty string.
        - Must be between 2 and 20 characters if provided.

    full_name : str
        Concatenation of first, middle, and last name (if applicable).

    password : str
        Hashed password of the user.
        - Must be at least 8 characters long.
        - Must include at least one uppercase letter, one lowercase letter, and one special character.

    success : int
        Number of successful Todos.
        - Default is 0.

    failure : int
        Number of failed Todos.
        - Default is 0.

    admin : bool
        Determines if the user has admin privileges.
        - Default is False (0).

    Methods:
    --------
    validate_length(self, key, value)
        Ensures `user_name`, `first_name`, `middle_name`, and `last_name` meet length constraints.

    validate_password(self, key, value)
        Ensures password meets complexity requirements using a regex.
    """

    id=db.Column(db.Integer,primary_key=True)
    user_name=db.Column(db.String(40),nullable=False,unique=True,index=True)
    first_name=db.Column(db.String(20),nullable=False)
    middle_name=db.Column(db.String(20),default='')
    last_name=db.Column(db.String(20),default='')
    full_name=db.Column(db.String(63))
    password=db.Column(db.String(150),nullable=False)
    success=db.Column(db.Integer,nullable=False,default=0)
    failure=db.Column(db.Integer,nullable=False,default=0)
    pending=db.Column(db.Integer,nullable=False,default=0)
    admin=db.Column(db.Boolean,default=0)

    @validates("user_name", "first_name", "middle_name", "last_name")
    def validate_length(self, key, value):
        """Validates the length constraints for the different name fields"""

        min_length=0
        # if key=="user_name":
        #     min_length=5
        # elif key == "first_name" : 
        #     min_length=2

        max_length = 40 if key == "user_name" else 20
        
        # if len(value) < min_length :
        #     raise ValueError(f"{key.replace('_', ' ').capitalize()} must be at least {min_length} characters long.")
        if len(value) > max_length:
            raise ValueError(f"{key.replace('_', ' ').capitalize()} must be at most {max_length} characters long.")
        return value
    
    @validates("password")
    def validate_password(self, key, value):
        """Validates password complexity using regex and length checking"""
        # Regex for password validation
        password_regex = re.compile(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,}$")

        if not password_regex.match(value):
            raise ValueError(
                "Password must be at least 8 characters long, include one uppercase letter, one lowercase letter, "
                "and one special character."
            )
        return value
    

@event.listens_for(User,"before_insert")
@event.listens_for(User,"before_update")
def before_event_listener(mapper,connection,target):
    target.full_name=' '.join((target.first_name,target.middle_name,target.last_name))
    
@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

class Todo(db.Model):
    """
    Todo Model for storing and managing user todo tasks.

    Attributes:
    ----------
    user_id : int
        Foreign key referencing the `user.id` to associate the task with a user.
        - Cannot be null.

    todo_id : int
        Primary key for identifying each todo item.
        - Automatically assigned.

    title : str
        Title of the todo task.
        - Must be between 3 and 100 characters.
        - Cannot be null.

    created_time : datetime
        Timestamp of when the todo task was created.
        - Defaults to the current time (`datetime.now()`).

    due_time : datetime (Optional)
        Deadline for completing the task.
        - Must be greater than the `created_time` if provided.

    Methods:
    --------
    validate_title(self, key, value)
        Ensures `title` meets the length constraint (3 to 100 characters).

    validate_due_time(self, key, value)
        Ensures `due_time` is later than `created_time`, if provided.
    """

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    todo_id = db.Column(db.Integer, primary_key=True)  # Automatically assigned
    title = db.Column(db.String(100), nullable=False) #Todo-task
    created_time = db.Column(db.DateTime, default=datetime.now())  # Time of creation
    due_time = db.Column(db.DateTime,nullable=False)  # Optional due date
    status = db.Column(db.String(1),nullable=False) #s-success f-failure p-pending 

    @validates("title")
    def validate_title(self, key, value):
        """Validates that the title length is between 3 and 100 characters."""
        if not (3 <= len(value) <= 100):
            raise ValueError("Title must be between 3 and 100 characters")
        return value

    @validates("due_time")
    def validate_due_time(self, key, value):
        """Validates that due_time is greater than created_time, if provided."""
        if value and value+timedelta(minutes=1) < self.created_time:
            raise ValueError("Due time must be greater than created time")
        return value
