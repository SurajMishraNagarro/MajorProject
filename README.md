# Advanced Python Assignment - To do app in Flask
## Overview
This project "Todo app" demonstrates a full stack web application incorporating : 
- __Backend__ : Flask
- __Database__ : sqlite, Flask SQL alchemy, ORM 
- __frontend__ : HTML, CSS, Javascript, bootstrap , font-awesome
- __Authentication__ : Flask-login
- __Forms__ : Flask-WTF
- __Security__ : CSRF Protection,werkzeug(for password hashing),ORM (to prevent SQL injections)
- __Jinja templates__ : for template inheritance and dynamic content from backend 
- __Migrations__ : For database updates

These technologies were binded together to create an interactive Todo App with __user authentication__, __CRUD operations__ and many more features as mentioned later .

## Project Structure

```
/Advanced Python Assignment  
    .venv                       # Virtual environement

    /app                        # Main app directory

        /static                 # JS and CSS files
            form.js             # JS for create and update 
                                # forms

            login.js            # JS for login.html
            signup.js           # JS for signup.html
            styles.css          # Custom css

        /templates              # HTML files
            base.html           # Base template with common 
                                # layout

            create_form.html    # form for new todo
            list.html           # lists the todos for a user
            login.html          # login page
            signup.html         # signup page
            update_form.html    # form for updating a todo

        ## PYTHON FILES
        auth.py                 # authentication related routes
        routes.py               # Todo related routes
        forms.py                # WT-forms     
        models.py               # models used in the project
        run.py                  # entry point
        __init__.py             # Initializes the application

    /instance  
    /migration                  # db migrations
    .env                        # environment variables
    README.md                   # project Description 
    requirements.txt            # venv requirements
```




## Installation and Setup

### 1. Python
- **Version**: 3.13  
- **Download & Install**: [Python Official Site](https://www.python.org/downloads/)  
- Verify installation:  
  ```sh
  python --version
  ```

### 2. Virtual Environment
#### Installation
- Install `venv`:
  ```sh
  python -m venv myenv
  ```
- Activate virtual environment:  
  - **Windows**:  
    ```sh
    myenv\Scripts\activate
    ```
  - **Mac/Linux**:  
    ```sh
    source myenv/bin/activate
    ```
- Deactivate:  
  ```sh
  deactivate
  ```

### 3. Dependencies Installation
Install python dependencies by executing the following in your terminal:
```sh
pip install -r requirements.txt
```

### 4. Frontend Dependencies
- **Bootstrap (CSS & JavaScript)**:  
  ```html
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  ```

- **Poppins Font (Google Fonts)**:
  ```html
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
  ```

- **Font Awesome (Icons)**:
  ```html
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  ```
### 5. Environment Variables (.env File)
Create a .env file in the root directory and add the following:
```
SECRET_KEY=your_secret_key_here
```

### 6. Other Technologies Used
- **HTML5**
- **CSS3**
- **JavaScript**

## Running the app
To run the app in your local machine , run the following command after navigating to your project directory.  
  
```python -m app.run```

This will execute __run.py__ which is the entry point of the application


## Features

- __User authentication__ : Signup, Login, Logout
- __Real time form validation__ : Using fetch requests from js to the backend as soon as user inputs something  
- __Add new todo__ 
- __Update pre-existing todo__
- __Mark todo as pending, success, failed__
- __List the todos by :__
    - __sorting__ : based on created time, deadline
    - __filtering__ : based on status (success, pending, failed)
- __Delete a todo__
- __Different alerts when deadline is approaching* or already passed__


__*__  deadline approaching is defined as when the due time is approaching less than 1 hour . This feature can be custom for a user or a particular todo  in the next updates .
