"""
Flask Blueprint for managing Todo application routes.

This module defines the main routes for the Todo application, allowing users to:
- Create, update, delete, and list their todos.
- Mark todos as pending, successful, or failed.
- Sort and filter todos based on status and due time.
- Track statistics on completed, failed, and pending todos.

Blueprint :
- main : handles routes for all the todo related tasks 

Key Features:
- Uses Flask-Login to ensure authentication for all operations.
- Implements session-based storage for sorting and filtering.
- Handles due time for todos and highlights urgent tasks.
- Provides functions for bulk deletion and resetting user statistics.

Routes:
- `/` -> Redirects authenticated users to the todo list, otherwise redirects to login.
- `/create` -> Allows users to create a new todo.
- `/list` -> Displays all todos based on sorting and filtering preferences.
- `/update/<int:id>` -> Updates a specific todo.
- `/delete` and `/delete/<int:id>` -> Deletes all or a specific todo.
- `/success/<int:id>`, `/failure/<int:id>`, `/pending/<int:id>` -> Changes the status of a todo.
- `/reset_stats` -> Resets the user's success, failure, and pending counts.

Dependencies:
- Flask, Flask-Login, SQLAlchemy
"""


from flask import render_template, Blueprint, request, redirect, url_for, session
from flask_login import login_required, current_user
from datetime import datetime, timedelta
from .models import Todo, db
from .forms import TodoForm, UpdateTodoForm
from prometheus_client import Counter

main = Blueprint("main", __name__)

# Prometheus Counters
todo_created = Counter('todo_created_total', 'Total number of todos created')
todo_deleted = Counter('todo_deleted_total', 'Total number of todos deleted')
todo_updated = Counter('todo_updated_total', 'Total number of todos updated')
todo_status_changed = Counter('todo_status_changed_total', 'Total number of todo status changes', ['from_status', 'to_status'])

@main.route("/")
def redirect_to_form():
    if current_user.is_authenticated:
        return redirect('list')
    return redirect(url_for('auth.login'))

@main.route('/create', methods=['POST', 'GET'])
@login_required
def create():
    form = TodoForm()
    if request.method == 'POST':
        title = form.title.data
        created_time = datetime.now()
        due_time_str = request.form.get('due_time')
        due_time = datetime.strptime(due_time_str, "%Y-%m-%dT%H:%M") if due_time_str else None

        todo_obj = Todo(user_id=current_user.id, title=title, created_time=created_time, due_time=due_time, status='p')
        current_user.pending += 1
        db.session.add(todo_obj)
        db.session.commit()

        # Increment Prometheus counter
        todo_created.inc()

        return redirect(url_for('main.list'))
    return render_template('create_form.html', form=form, current_time=datetime.now())

@main.route('/list')
@login_required
def list():
    sort_by = request.args.get('sort', session.get('sort_by', 'due_time'))
    sort_by = sort_by if sort_by in ('due_time', 'created_time') else 'due_time'
    todo_status = request.args.get('todo_status', session.get('todo_status', 'p'))
    session['sort_by'] = sort_by
    session['todo_status'] = todo_status if todo_status in ('p', 's', 'f') else 'p'
    sort_attr = getattr(Todo, sort_by)
    current_time = datetime.now()
    one_hour_later = current_time + timedelta(hours=1)

    if todo_status == 'u':
        todos = Todo.query.filter(
            Todo.user_id == current_user.id,
            Todo.status == 'p',
            Todo.due_time.between(current_time, one_hour_later)
        )
    elif todo_status == 'd':
        todos = Todo.query.filter(
            Todo.user_id == current_user.id,
            Todo.status == 'p',
            Todo.due_time < current_time
        )
    else:
        todos = Todo.query.filter(
            Todo.user_id == current_user.id,
            Todo.status == todo_status
        )
    todos = todos.order_by(sort_attr)

    urgent_todos_count = Todo.query.filter(
        Todo.user_id == current_user.id,
        Todo.due_time.between(current_time, one_hour_later),
        Todo.status == 'p'
    ).count()
    deadlined_todos_count = Todo.query.filter(
        Todo.user_id == current_user.id,
        Todo.due_time < current_time,
        Todo.status == 'p'
    ).count()

    return render_template(
        "list.html",
        Todo=Todo,
        todos=todos,
        current_time=current_time,
        success=current_user.success,
        failure=current_user.failure,
        pending=current_user.pending,
        first_name=current_user.first_name,
        urgent_todos_count=urgent_todos_count,
        deadlined_todos_count=deadlined_todos_count,
        todo_status=todo_status
    )

@main.route("/update/<int:id>", methods=['POST', 'GET'])
@login_required
def update(id):
    form = UpdateTodoForm()
    if request.method == 'POST':
        todo = Todo.query.get(id)
        if form.validate_on_submit():
            prev_title = todo.title
            todo.title = form.title.data
            due_time_str = request.form.get('due_time')
            due_time = datetime.strptime(due_time_str, "%Y-%m-%dT%H:%M") if due_time_str else None
            todo.due_time = due_time
            db.session.commit()

            # Increment update counter
            todo_updated.inc()

            return redirect(url_for('main.list'))
        return "not validated"
    else:
        todo = Todo.query.get(id)
        if not todo or todo.user_id != current_user.id:
            return "todo not found"
        created_time = todo.created_time
        return render_template(
            'update_form.html',
            Todo=Todo,
            todo_id=id,
            created_time=created_time,
            form=form
        )

@main.route('/delete')
@login_required
def delete_all():
    db.session.query(Todo).delete()
    current_user.success = 0
    current_user.failure = 0
    current_user.pending = 0
    db.session.commit()

    # Increment delete counter
    todo_deleted.inc()

    return f"<h1> deleted all todos for {current_user.id}</h1>"

@main.route('/delete/<int:id>')
@login_required
def delete_todo(id):
    todo = Todo.query.get(id)
    if not todo or todo.user_id != current_user.id:
        return "todo not found"
    status_before = todo.status
    if todo:
        if status_before == 's':
            current_user.success -= 1
        elif status_before == 'f':
            current_user.failure -= 1
        elif status_before == 'p':
            current_user.pending -= 1
        db.session.delete(todo)
        db.session.commit()

        # Increment delete counter
        todo_deleted.inc()

    return redirect(url_for('main.list'))

@main.route('/success/<int:id>')
@login_required
def success(id):
    todo = Todo.query.get(id)
    if not todo or todo.user_id != current_user.id:
        return "todo not found"
    from_status = todo.status
    if from_status in ('p', 'f'):
        current_user.success += 1
        if from_status == 'p':
            current_user.pending -= 1
        else:
            current_user.failure -= 1
        todo.status = 's'
        db.session.commit()

        # Increment status change counter
        todo_status_changed.labels(from_status=from_status, to_status='s').inc()

    return redirect(url_for('main.list'))

@main.route('/failure/<int:id>')
@login_required
def failure(id):
    todo = Todo.query.get(id)
    if not todo or todo.user_id != current_user.id:
        return "todo not found"
    from_status = todo.status
    if from_status in ('s', 'p'):
        current_user.failure += 1
        if from_status == 'p':
            current_user.pending -= 1
        else:
            current_user.success -= 1
        todo.status = 'f'
        db.session.commit()

        # Increment status change counter
        todo_status_changed.labels(from_status=from_status, to_status='f').inc()

    return redirect(url_for('main.list'))

@main.route("/pending/<int:id>")
@login_required
def pending(id):
    todo = Todo.query.get(id)
    if not todo or todo.user_id != current_user.id:
        return "todo not found"
    from_status = todo.status
    if from_status in ('s', 'f'):
        current_user.pending += 1
        if from_status == 'f':
            current_user.failure -= 1
        else:
            current_user.success -= 1
        todo.status = 'p'
        db.session.commit()

        # Increment status change counter
        todo_status_changed.labels(from_status=from_status, to_status='p').inc()

    return redirect(url_for('main.list'))
