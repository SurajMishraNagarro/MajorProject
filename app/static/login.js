//Javascript for login.html

const form = document.getElementById("loginForm")
// userName=document.getElementById("userName")
// password=document.getElementById("password")
const userNameValidation=document.getElementById("userNameValidation")
const passwordValidation=document.getElementById("passwordValidation")
const invalidCredentialsAlert=document.getElementById("invalidCredentialsAlert")

//add event listener for submit
form.addEventListener("submit",function(event){
    event.preventDefault() //prevent submission before validation

    let userName=form.userName.value
    let password=form.password.value
    userNameValidation.classList.add("d-none")
    passwordValidation.classList.add("d-none")

    //check whether username is empty
    if (!userName){
        
        userNameValidation.innerText = "*required"
        userNameValidation.classList.remove("d-none")
    }

    //check whether password is empty
    if (!password){
        
        passwordValidation.innerText = "*required"
        passwordValidation.classList.remove("d-none")

    }

    //send the request to the backend via post request method
    if (userName && password) {
        fetch(loginURL, {
            method: "POST",
            headers: { "Content-Type": "application/json" ,
                "X-CSRFToken": csrfToken
            },
            //send the username and password
            body: JSON.stringify({ user_name : userName , password : password })
        })
        .then(response => response.json())
        .then(data =>{
            //check the valid key in the response 
            if (!data.valid){
                event.preventDefault()
                invalidCredentialsAlert.classList.remove("d-none")
            }
            else{
                //redirect to the specified url in the response("list.html")
                window.location.href=data.redirect
            }
            
        }
        )
        .catch(error =>console.log(error))
    }
    
})
